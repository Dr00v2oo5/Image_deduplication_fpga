# Top module
TOP = tb_loader

# Source files
SRCS = tb_loader.v \
       pixel_loader.v \
       duplicate_detector.v \
       image_dedup_top.v

# Verilator flags
VERILATOR = verilator
VERILATOR_FLAGS = --binary -Wall --sv --trace

# Output directory
OBJ_DIR = obj_dir

# Default target
all: run

# Build and run
run:
	$(VERILATOR) $(VERILATOR_FLAGS) $(SRCS) --top-module $(TOP)
	./$(OBJ_DIR)/V$(TOP)

# Clean build artifacts
clean:
	rm -rf $(OBJ_DIR) *.vcd

.PHONY: all run clean
