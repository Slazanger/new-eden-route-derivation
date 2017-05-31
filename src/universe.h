#pragma once

#include <xmmintrin.h>

#define LIMIT_ENTITIES 500000
#define LIMIT_ENTITIES_PER_SYSTEM 256
#define LIMIT_SYSTEMS 9000

enum entity_type {
    CELESTIAL, STATION, STARGATE
};

enum movement_type {
    JUMP, GATE, WARP, STRT
};

struct trip {
    double jump_range;
    double warp_speed;
    double align_time;
    double gate_cost;
};

struct waypoint {
    struct entity *entity;
    enum movement_type type;
};

struct route {
    int length, loops;
    double cost;
    struct waypoint points[];
};

struct entity {
    __m128 pos;
    int id, seq_id;
    char *name;

    enum entity_type type;
    int group_id;
    struct system *system;
    struct entity *destination;
} __attribute__ ((aligned(64)));

struct system {
    __m128 pos;
    int id, seq_id;
    char *name;

    int entity_count;
    struct entity *entities;
} __attribute__ ((aligned(64)));

struct universe {
    int system_count, entity_count, stargate_count;
    struct system *systems;
    struct entity *entities, *last_entity;

    int *system_map, *stargate_map, *celestial_map, *station_map;
};

struct universe *universe_init(unsigned int, unsigned int);
void universe_free(struct universe *);
void universe_add_system(struct universe *, int, char *, double, double, double, unsigned int);
struct entity *universe_add_entity(struct universe *, int, int, enum entity_type, char *, double, double, double, struct entity *);
void universe_route(struct universe *, int, int, struct trip *);
struct entity *universe_get_entity(struct universe *, int);
struct entity *universe_get_entity_or_default(struct universe *, int);
