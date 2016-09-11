MY_SRC_DIR = ~/GitHub/C-Plus/luna
PROGRAMS = $(MY_SRC_DIR)/bin/luna
ACE_ROOT = ~/GitHub/ACE
ACE_INC = -I$(ACE_ROOT)/include
ACE_LINK = -L$(ACE_ROOT)/lib
ACE_CCFLAG = -DACE_HAS_EXCEPTIONS -D__ACE_INLINE__
ACE_LIBS = -lACE 
USER_FLAGS = -Wlong-long -Wformat -Wpointer-arith -Wno-trigraphs -fpermissive -ggdb -mpreferred-stack-boundary=4 -fno-stack-protector -pthread -m64 -Wall -Wno-deprecated -lpthread -ldl

CC_ARG = -I./ $(ACE_INC) $(ACE_CCFLAG) $(USER_FLAGS)
LINK_ARG = $(ACE_LIBS) $(ACE_LINK) -L/usr/lib

SOURCE = $(shell find $(MY_SRC_DIR)/ -name '*.cpp')
OBJECTS = $(SOURCE:.cpp=.o)

OUTPUT_FLAG = -o $@
CCC = gcc
CXX = g++
SOLINK.cc = $(CXX) -shared

#deps
DEPS = $(SOURCE:.cpp=.d)

####
.PHONY:all depand
all:$(PROGRAMS)

display_env:
	@echo "[compiler: \"$(CCC)\" ARGS: \"$(CC_ARG)\"]"
	@echo "[LINKER: \"$(CCC)\" Args: \"$(LINK_ARG)\"]"

clean:
	@echo "[Cleaning ...]"
	@rm -rf $(PROGRAMS)
	@rm -rf $(OBJECTS) $(DEPS) core ir.out
	@echo "[$(PROGRAMS) $(OBJECTS) $(DEPS) are removed..]"

depand:$(DEPS)
	@echo "Gen Depand OK"

%.d:%.cpp
	@$(COMPILE.cc) $(CC_ARG) -MP -MM -MT '$(patsubst %.cpp,%.o,$<)' $< > $@

ifeq ($(inldeps),1)
	-include $(DEPS)
endif

%.o:%.cpp
	@echo "[Compiling $< ...]"
	@$(COMPILE.cc) $(CC_ARG) $< $(OUTPUT_FLAG)

$(PROGRAMS):$(OBJECTS)
	@echo "[Linking $@  ...]"
	@$(LINK.cc) $(OUTPUT_FLAG) $(OBJECTS) $(LINK_ARG)
	@echo "[compiler end time --`date`]"

all:$(OBJECTS)
