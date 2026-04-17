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
    return hash;

};

Hashmap create(){
    Hashmap h;
    h.capacity=17;
    h.count=0;
    h.threshold=0.75;
    h.buckets= malloc(h.capacity);
    return h;
};

void resize(Hashmap* h){
    int new_capacity= malloc(h->capacity*2);
    for(int i=0;i<=h->capacity;i++){

    }

    
};

void set(Hashmap* h, char* key, void* value){
    unsigned long hash = djb2(key);
    int index = hash % h->capacity;
};
