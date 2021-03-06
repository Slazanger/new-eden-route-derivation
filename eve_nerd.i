%module eve_nerd

%feature("autodoc", "1");

%{
#include "universe.hpp"
#include "parameters.hpp"

namespace swig {
    template <typename T> swig_type_info *type_info();

    template <> swig_type_info *type_info<Celestial>() {
        return SWIGTYPE_p_Celestial;
    };
}
%}

%include <std_string.i>
%include <std_vector.i>
%include <std_map.i>

%template(WaypointList) std::vector<waypoint>;
%template(DistanceMap) std::map<Celestial *, float>;
%template(CelestialVector) std::vector<Celestial *>;
%template(IntVector) std::vector<int>;

%include "universe.hpp"
%include "parameters.hpp"

%extend Route {
%pythoncode {
    @property
    def start(self):
        return self.points[0].entity

    @property
    def end(self):
        return self.points[-1].entity

    def __repr__(self):
        return "<Route '%s' to '%s'>" % (self.start.name, self.end.name)
}
}

%extend Universe {
%pythoncode {
    def get_systems(self):
        for i in range(self.system_count):
            yield self.get_system_by_seq_id(i)

    def get_entities(self):
        for i in range(self.entity_count):
            yield self.get_entity_by_seq_id(i)
}
}

%extend System {
%pythoncode {
    def get_entities(self):
        for i in range(self.entity_count):
            yield self.get_entity_by_internal_id(i)

    def __str__(self):
        return self.name

    def __repr__(self):
        return "<System %d : '%s'>" % (self.id, self.name)
}
}

%extend Celestial {
%pythoncode {
    def __str__(self):
        return self.name

    def __repr__(self):
        return "<Celestial %d : '%s'>" % (self.id, self.name)
}
}

%extend waypoint {
%pythoncode {
    def __repr__(self):
        return "<Waypoint type %d to %s>" % (self.type, str(self.entity))
}
}
