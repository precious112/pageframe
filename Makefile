# Pageframe - Key-Value Database Engine
# Usage:
#   make            Build debug binary
#   make release    Build optimized binary
#   make test       Build and run all tests
#   make clean      Remove all build artifacts
#   make run        Build and run the main binary

CC        = clang
CFLAGS    = -Wall -Wextra -Werror -pedantic -std=c11 -Iinclude
DEBUG     = -g -O0 -DDEBUG
RELEASE   = -O2 -DNDEBUG

SRC_DIR   = src
BUILD_DIR = build
TEST_DIR  = tests

# Find all .c files in src/
SRCS      = $(wildcard $(SRC_DIR)/*.c)
OBJS      = $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
TARGET    = $(BUILD_DIR)/pageframe

# Find all test files
TEST_SRCS = $(wildcard $(TEST_DIR)/test_*.c)
TEST_BINS = $(TEST_SRCS:$(TEST_DIR)/%.c=$(BUILD_DIR)/%)

# Default: debug build
all: CFLAGS += $(DEBUG)
all: $(TARGET)

release: CFLAGS += $(RELEASE)
release: $(TARGET)

$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# --- Tests ---
# Each test_*.c compiles to its own binary and links with all src objects
# except main.o (tests provide their own main).
LIB_OBJS = $(filter-out $(BUILD_DIR)/main.o, $(OBJS))

test: CFLAGS += $(DEBUG)
test: $(OBJS) $(TEST_BINS)
	@echo "--- Running tests ---"
	@failed=0; \
	for t in $(TEST_BINS); do \
		echo "RUN  $$t"; \
		if $$t; then \
			echo "PASS $$t"; \
		else \
			echo "FAIL $$t"; \
			failed=1; \
		fi; \
	done; \
	if [ $$failed -eq 1 ]; then echo "Some tests failed."; exit 1; \
	else echo "All tests passed."; fi

$(BUILD_DIR)/test_%: $(TEST_DIR)/test_%.c $(LIB_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< $(LIB_OBJS)

# --- Utilities ---
run: all
	./$(TARGET)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all release test run clean
