import core

## Return the data for a feature in a features array.

## If the feature is not found, nil is returned.  Note that this function is
## only useful for features with data, and can not detect features that are
## present but have nil data.

proc lv2FeaturesData*(features: ptr UncheckedArray[ptr Lv2Feature], uri: string): pointer =
    if features != nil:
        var i = 0
        while true:
            let feature = features[i]
            if feature == nil:
                break
            
            if feature[].uri == uri.cstring:
                return feature[].data
            
            inc i
    
    return nil

## Query a features array.
## 
## This function allows getting several features in one call, and detect
## missing required features, with the same caveat of lv2_features_data().
## 
## The arguments should be a series of const char* uri, void** data, bool
## required, terminated by a NULL URI.  The data pointers MUST be initialized
## to NULL.  For example:
## 
## LV2_URID_Log* log = NULL;
## LV2_URID_Map* map = NULL;
## const char* missing = lv2_features_query(
##      features,
##      LV2_LOG__log,  &log, false,
##      LV2_URID__map, &map, true,
##      NULL);
##
## 
## @return NULL on success, otherwise the URI of this missing feature.
