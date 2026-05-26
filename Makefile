CC = gcc
CFLAGS = -Wall -Wextra -g -Iinclude

SRCS = $(wildcard src/*.c)

OBJS = $(SRCS:.c=.o)

TARGET = ryshell

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

# Clean up build files
clean:
	rm -f src/*.o $(TARGET)
