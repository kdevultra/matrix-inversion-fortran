FC = gfortran
FFLAGS = -Wall -Wno-tabs -O2
TARGET = main
SRCS = matrix.f95 main.f95
OBJS = matrix.o main.o
MODS = matrix_module.mod

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $(OBJS)

matrix.o: matrix.f95
	$(FC) $(FFLAGS) -c matrix.f95

main.o: main.f95 matrix.o
	$(FC) $(FFLAGS) -c main.f95

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJS) $(MODS) $(TARGET)
