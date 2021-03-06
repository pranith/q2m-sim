#
#Copyright (c) <2013>, <Georgia Institute of Technology> All rights reserved.

#Redistribution and use in source and binary forms, with or without modification, are permitted 
#provided that the following conditions are met:

#Redistributions of source code must retain the above copyright notice, this list of conditions 
#and the following disclaimer.

#Redistributions in binary form must reproduce the above copyright notice, this list of 
#conditions and the following disclaimer in the documentation and/or other materials provided 
#with the distribution.

#Neither the name of the <Georgia Institue of Technology> nor the names of its contributors 
#may be used to endorse or promote products derived from this software without specific prior 
#written permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
#IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
#AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
#CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
#SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
#THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
#OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
#POSSIBILITY OF SUCH DAMAGE.
#

XED ?= ./xed2-intel64
QSIM_PREFIX ?= /usr/local
DISTORM ?= ./distorm3-3
DISTORM_VERSION ?= 3

CXXFLAGS ?= -O2 -Iinclude -I$(DISTORM)/include -I$(QSIM_PREFIX)/include -I$(XED)/include 
LDFLAGS ?= -L$(QSIM_PREFIX)/lib -L$(XED)/lib -L$(DISTORM)
LDLIBS ?= -ldl -lqsim -lxed -lz -ldistorm$(DISTORM_VERSION)


vpath %.h ./include
vpath %.cpp ./src

EXE = trace_generator
SRCS = trace_generator.cpp all_knobs.cpp knob.cpp 
HEADERS = data_types.h all_knobs.h knob.h trace_generator.h 
OBJS = $(patsubst %.cpp,obj/%.o,$(SRCS))

# default target is ``all''
all : check_dep $(EXE)

check_dep:
	@test -s $(XED)/lib/libxed.a || { echo -e "Couldn't find libxed.a under $(XED)/lib/\nSet the correct path to XED in the Makefile or run get_xed.sh from ./scripts\nExiting ..."; exit 1; }
	@test -s $(DISTORM)/libdistorm$(DISTORM_VERSION).a || { echo -e "Couldn't find libdistorm$(DISTORM_VERSION).a under $(DISTORM)\nSet the correct path to DISTORM in the Makefile or run get_distorm.sh from ./scripts\nExiting ..."; exit 1; }
	@test -s $(QSIM_PREFIX)/lib/libqsim.so || { echo -e "Couldn't find libqsim.so under $(QSIM_PREFIX)/lib\nSet the correct path to QSIM_PREFIX in the Makefile or fetch and build qsim from https://github.com/cdkersey/qsim\nExiting ..."; exit 1; }

obj:
	@mkdir -p obj 

$(OBJS): $(HEADERS) | obj 

# define a rule for .cpp -> .o
obj/%.o : %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(EXE) : $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

clean :
	@rm -rf $(EXE) obj 

print-%:
	@echo '$*=$($*)'
