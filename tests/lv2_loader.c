/*
 * lv2_loader.c
 *
 * Load the LV2 plugin shared library from the path given on the command line
 * and try to instantiate the first plugin, then de-instantiate the plugin and
 * unload the shared library.
 *
 * Do that repeatedly for the number of times given on the command line
 * (default: 100).
 *
 * May be useful to check for memory leaks.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <dlfcn.h>
#include <libgen.h>

#include <lv2/core/lv2.h>

static int parse_loop_count(int argc, char** argv) {
    long loops = 100; // default
    if (argc >= 3) {
        char* end = NULL;
        loops = strtol(argv[2], &end, 10);
        if (end == argv[2] || *end != '\0' || loops <= 0 || loops > INT_MAX) {
            fprintf(stderr, "Invalid loop count '%s', using default 100\n", argv[2]);
            loops = 100;
        }
    }
    return (int)loops;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s /path/to/plugin.so [loop_count]\n", argv[0]);
        return 1;
    }

    const char* lib_path = argv[1];
    int loops = parse_loop_count(argc, argv);

    // Derive bundle (parent directory) path using dirname()
    char path_copy[PATH_MAX];
    strncpy(path_copy, lib_path, sizeof(path_copy) - 1);
    path_copy[sizeof(path_copy) - 1] = '\0';

    char* dir = dirname(path_copy);
    char bundle_path[PATH_MAX];
    strncpy(bundle_path, dir ? dir : ".", sizeof(bundle_path) - 1);
    bundle_path[sizeof(bundle_path) - 1] = '\0';

    printf("Bundle path: %s\n", bundle_path);
    printf("Running %d iterations...\n", loops);

    for (int i = 0; i < loops; ++i) {
        void* so = dlopen(lib_path, RTLD_NOW | RTLD_LOCAL);
        if (!so) {
            fprintf(stderr, "dlopen failed: %s\n", dlerror());
            return 2; // exit on failure to load
        }

        dlerror(); // Clear any existing error

        // Try lv2_lib_descriptor first
        typedef const LV2_Lib_Descriptor* (*lv2_lib_descriptor_fn)(
            const char* bundle_path,
            const LV2_Feature* const* host_features);

        lv2_lib_descriptor_fn libdesc_sym =
            (lv2_lib_descriptor_fn)dlsym(so, "lv2_lib_descriptor");

        const char* err = dlerror();

        if (!err && libdesc_sym) {
            const LV2_Lib_Descriptor* libdesc = libdesc_sym(bundle_path, NULL);

            // If lv2_lib_descriptor returns NULL, try legacy lv2_descriptor;
            // if that also fails/returns NULL, clean up and exit.
            if (!libdesc) {
                dlerror();
                typedef const LV2_Descriptor* (*lv2_descriptor_fn)(uint32_t index);
                lv2_descriptor_fn lv2desc_sym =
                    (lv2_descriptor_fn)dlsym(so, "lv2_descriptor");
                err = dlerror();

                if (err || !lv2desc_sym) {
                    fprintf(stderr, "lv2_lib_descriptor returned NULL and lv2_descriptor not found: %s\n",
                            err ? err : "symbol not found");
                    dlclose(so);
                    return 3; // exit per instructions
                }

                const LV2_Descriptor* desc = lv2desc_sym(0);
                if (!desc) {
                    fprintf(stderr, "Both lv2_lib_descriptor and lv2_descriptor returned NULL\n");
                    dlclose(so);
                    return 4; // exit per instructions
                }

                // Instantiate and cleanup instance
                LV2_Handle instance = NULL;
                if (desc->instantiate) {
                    instance = desc->instantiate(desc, 48000.0, bundle_path, NULL);
                }

                if (!instance) {
                    fprintf(stderr, "instantiate returned NULL (legacy path)\n");
                } else {
                    if (desc->cleanup) {
                        desc->cleanup(instance);
                    }
                }

                dlclose(so);
                continue; // next iteration
            }

            // Normal lib-descriptor path
            const LV2_Descriptor* desc = NULL;
            if (libdesc->get_plugin) {
                desc = libdesc->get_plugin(NULL, 0);
            }

            if (!desc) {
                fprintf(stderr, "get_plugin returned NULL for index 0\n");
                if (libdesc->cleanup) {
                    libdesc->cleanup(NULL);
                }
                dlclose(so);
                // Not one of the "both missing/NULL" cases, so continue
                continue;
            }

            LV2_Handle instance = NULL;
            if (desc->instantiate) {
                instance = desc->instantiate(desc, 48000.0, bundle_path, NULL);
            }

            if (!instance) {
                fprintf(stderr, "instantiate returned NULL (lib path)\n");
            } else {
                if (desc->cleanup) {
                    desc->cleanup(instance);
                }
            }

            // Cleanup library descriptor (with NULL handle, as requested)
            if (libdesc->cleanup) {
                libdesc->cleanup(NULL);
            }

            dlclose(so);
            continue; // next iteration
        }

        // Fallback: try legacy lv2_descriptor (no LV2_Lib_Descriptor symbol available)
        dlerror(); // Clear error before next dlsym
        typedef const LV2_Descriptor* (*lv2_descriptor_fn)(uint32_t index);
        lv2_descriptor_fn lv2desc_sym =
            (lv2_descriptor_fn)dlsym(so, "lv2_descriptor");
        err = dlerror();

        if (err || !lv2desc_sym) {
            fprintf(stderr, "Neither lv2_lib_descriptor nor lv2_descriptor found: %s\n",
                    err ? err : "symbol not found");
            dlclose(so);
            return 5; // exit per instructions
        }

        const LV2_Descriptor* desc = lv2desc_sym(0);
        if (!desc) {
            fprintf(stderr, "lv2_descriptor(0) returned NULL\n");
            dlclose(so);
            return 6; // exit per instructions
        }

        LV2_Handle instance = NULL;
        if (desc->instantiate) {
            instance = desc->instantiate(desc, 48000.0, bundle_path, NULL);
        }

        if (!instance) {
            fprintf(stderr, "instantiate returned NULL (legacy path)\n");
        } else {
            if (desc->cleanup) {
                desc->cleanup(instance);
            }
        }

        dlclose(so);
    }

    return 0;
}
