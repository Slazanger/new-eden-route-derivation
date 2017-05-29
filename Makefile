CC = gcc
CFLAGS = -mtune=native -Wall -Wextra -std=gnu11 -Og -g -Wno-missing-field-initializers -Isrc/ -MMD
LDLIBS += -lreadline -lm
SRC = $(wildcard src/*.c)

.PHONY: clean

main: $(patsubst %.c,%.o, $(SRC))
	$(CC) $(LDFLAGS) -o main $^ $(LDLIBS)

clean:
	rm main $(SRC:.c=.o) $(SRC:.c=.d)

-include $(SRC:.c=.d)