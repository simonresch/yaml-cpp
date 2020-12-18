#include <string>
#include <stdint.h>
#include "yaml-cpp/yaml.h"

// fuzz_target.cc
extern "C" int LLVMFuzzerTestOneInput(const char *data, size_t size) {
   try {
       if (size > 0) {
       YAML::Node doc = YAML::Load(std::string(data, size));
       }
   } catch (const YAML::Exception& e) {
   } catch (const std::exception& e) { }
 return 0;  // Non-zero return values are reserved for future use.
}
