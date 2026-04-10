typedef struct Entry
{
    char* key;
    void* value;
    struct Entry* next; //pointer to next entry

} Entry;

typedef struct 
{
    int capacity;
    int count;
    float threshold;
    Entry** buckets;
} Hashmap;

unsigned long djb2(char* key){
    unsigned long hash=5381;
    while(*key){
        hash= hash*33 + *key;
        key++;
    }

};
