/*
 * $File: snake.c
 * $Date: Wed Jan 01 23:14:50 2014 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */
#include "slide1.h"
#include "slide2.h"
#include "slide3.h"
#include "slide4.h"
#include "slide5.h"
#include "slide6.h"
#include "slide7.h"
#include "slide8.h"
#include "slide9.h"
#include "slide10.h"
#include "slide11.h"
#include "slide12.h"
#include "slide13.h"
#include "slide14.h"
#include "system.h"

// all images are of the same size
#define IMAGE_SIZE	15		

// sceen size measured in number of images
#define SCREEN_WIDTH	25
#define SCREEN_HEIGHT	20
#define SCREEN_HEIGHT_POW2	32

#define COLOR_DEATH		0b11100000

#define SNAKE_NR_CELL	(SCREEN_WIDTH * SCREEN_HEIGHT + 1)

#define MOVE_ADJUSTMENT	50

#define RAND_MAX		0xFFFFFFFFu

static memio_ptr_t const
	vga_buffer_game = ((memio_ptr_t)0xBA000000) +
		(400 - (SCREEN_WIDTH * IMAGE_SIZE)) / 2;

typedef enum {DIR_NONE, DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT} dir_t;
typedef enum {MAP_SNAKE, MAP_APPLE, MAP_EMPTY} map_t;
typedef struct {
	int x, y;
} coord_t;

typedef struct {
	dir_t head_dir;
	coord_t coord[SNAKE_NR_CELL];
	int head, tail;
} snake_t;

static snake_t snake;
static map_t map[SCREEN_HEIGHT_POW2][SCREEN_WIDTH];
static uint32_t saved_c0_status, cur_nr_apple, score;

static void draw_image(img_ptr_t img, int row, int col);
static void draw_death_line(int x0, int y0, int dx, int dy);
static void update_snake(dir_t new_dir);
static void game_over(int x, int y) __attribute__((noreturn));
static void apply_dir_to_coord(coord_t *coord, dir_t dir);
static inline coord_t* forward_cirqueue_ptr(int *ptr); 
static void exit() __attribute__((noreturn));
static uint32_t rand();
static void gen_apple();
static void write_debug_char(int ch);
static void write_debug_str(const char *str);
static void write_debug_str_num(const char *str, uint32_t n);
static int is_opposite_dir(dir_t d0, dir_t d1);

// range can not exceed 1024
static inline uint32_t rand_in_range(uint32_t range);


void draw_image(img_ptr_t img, int row, int col) {
	row *= IMAGE_SIZE;
	col *= IMAGE_SIZE;
	memio_ptr_t ptr = vga_buffer_game + row * VGA_ROW_SIZE + col;
	int i, j;
	for (i = 0; i < IMAGE_SIZE; i ++) {
		for (j = 0; j < IMAGE_SIZE; j ++)
			*(ptr ++) = *(img ++);
		ptr += VGA_ROW_SIZE - IMAGE_SIZE;
	}
}

void update_snake(dir_t new_dir) {

	coord_t old_head = snake.coord[snake.head],
			*new_head = forward_cirqueue_ptr(&snake.head);
	*new_head = old_head;

	apply_dir_to_coord(new_head, new_dir);
	snake.head_dir = new_dir;

	map_t *mnew = &map[new_head->y][new_head->x];
	if (*mnew == MAP_SNAKE)
		game_over(new_head->x, new_head->y);

	// draw_image(IMG_SNAKE, new_head->y, new_head->x);

	if (*mnew != MAP_APPLE) {
		coord_t old_tail = snake.coord[snake.tail];
		forward_cirqueue_ptr(&snake.tail);
		// draw_image(IMG_EMPTY, old_tail.y, old_tail.x);
		map[old_tail.y][old_tail.x] = MAP_EMPTY;
	} else {
		cur_nr_apple --;
		score ++;
	}

	*mnew = MAP_SNAKE;

}

coord_t* forward_cirqueue_ptr(int *ptr) {
	(*ptr) ++;
	if (*ptr == SNAKE_NR_CELL)
		*ptr = 0;
	return snake.coord + *ptr;
}

void apply_dir_to_coord(coord_t *coord, dir_t dir) {
	switch (dir) {
		case DIR_UP:
			coord->y --;
			if (coord->y < 0)
				coord->y = SCREEN_HEIGHT - 1;
			break;
		case DIR_DOWN:
			coord->y ++;
			if (coord->y == SCREEN_HEIGHT)
				coord->y = 0;
			break;
		case DIR_LEFT:
			coord->x --;
			if (coord->x < 0)
				coord->x = SCREEN_WIDTH - 1;
			break;
		case DIR_RIGHT:
			coord->x ++;
			if (coord->x == SCREEN_WIDTH)
				coord->x = 0;
			break;
		case DIR_NONE:
			exit();	// should never happen
	}
}

void exit() {
	enable_interrupt(saved_c0_status);
	sys_redraw_console();
	puts("score: ");
	print_dec(score);
	sys_putc('\n');
	sys_exit(0);
}

void init_snake() {
	score = 0;
	memio_ptr_t buf = vga_buffer;
	int i, j;
	int d0 = vga_buffer_game - vga_buffer,
		d1 = d0 + SCREEN_WIDTH * IMAGE_SIZE;
	d0 --;

	for (i = 0; i < 300; i ++) {
		for (j = 0; j < 400; j ++)
			buf[j] = 0;
		buf[d0] = 255;
		buf[d1] = 255;
		buf += 512;
	}

	for (i = 0; i < SCREEN_HEIGHT; i ++)
		for (j = 0; j < SCREEN_WIDTH; j ++)
			map[i][j] = MAP_EMPTY;

	snake.tail = 0;
	snake.head = 3;
	for (i = 0; i <= snake.head; i ++) {
		snake.coord[i].x = i;
		snake.coord[i].y = 0;
		map[0][i] = MAP_SNAKE;
		// draw_image(IMG_SNAKE, 0, i);
	}
	snake.head_dir = DIR_RIGHT;
	cur_nr_apple = 0;
}

void write_debug_char(int ch) {
	while (!(*com_stat & 1));
	*com_data = 't';
	while (!(*com_stat & 1));
	*com_data = ch;
}

void game_over(int x, int y) {
	x = x * IMAGE_SIZE + IMAGE_SIZE / 2;
	y = y * IMAGE_SIZE + IMAGE_SIZE / 2;
	int i = 0;
	for (i = -2; i <= 2; i ++) {
		draw_death_line(x + i, y, 1, 1);
		draw_death_line(x + i, y, -1, -1);
		draw_death_line(x + i, y, 1, -1);
		draw_death_line(x + i, y, -1, 1);
		draw_death_line(x, y + i, 1, 1);
		draw_death_line(x, y + i, -1, -1);
		draw_death_line(x, y + i, 1, -1);
		draw_death_line(x, y + i, -1, 1);
	}
	for (; ; ) {
		int c = get_key();
		if (c == 'q') 
			exit();
	}
}

void draw_death_line(int x, int y, int dx, int dy) {
	int i;
	memio_ptr_t ptr = vga_buffer_game + y * VGA_ROW_SIZE;
	for (i = 0; i < 10; i ++) {
		ptr[x] = COLOR_DEATH;
		ptr += dy * VGA_ROW_SIZE;
		y += dy;
		x += dx;

		if (x < 0 || x >= SCREEN_WIDTH * IMAGE_SIZE ||
				y < 0 || y >= SCREEN_HEIGHT * IMAGE_SIZE)
			return;
	}
}

uint32_t rand() {
	// see wiki,  multiply-with-carry by George Marsaglia
	static uint32_t m_z, m_w;
	if (!m_z || !m_w) {
		m_z = read_c0_count();
		m_w = ~read_c0_count();
	}
	m_z = 36969 * (m_z & 65535) + (m_z >> 16);
	m_w = 18000 * (m_w & 65535) + (m_w >> 16);
	return (m_z << 16) + m_w;  /* 32-bit result */
}

uint32_t rand_in_range(uint32_t range) {
	return ((rand() >> 10) * range) >> 22;
	/*
	   well, signed multiply is not applicable
	uint32_t rst, r = rand();
	asm volatile (
		"mult %1, %2\n"
		"mfhi %0"
		: "=r"(rst)
		: "r"(r), "r"(range)
	);
	return rst;
	*/
}


// void gen_apple() {
// 	uint32_t r = rand_in_range(50);
// 	if (r >= cur_nr_apple + 45) {
// 		int try_remain = 5;
// 		for (; try_remain --; ) {
// 			int x = rand_in_range(SCREEN_WIDTH),
// 				y = rand_in_range(SCREEN_HEIGHT);
// 			if (y < 0 || y >= SCREEN_HEIGHT ||
// 					x < 0 || x >= SCREEN_WIDTH)
// 				continue;

// 			map_t *m = &map[y][x];
// 			if (*m == MAP_EMPTY) {
// 				*m = MAP_APPLE;
// 				draw_image(IMG_APPLE, y, x);
// 				cur_nr_apple ++;
// 				return;
// 			}
// 		}
// 	}
// }

//	row x, column y
void draw_image_2(char *img,int x,int y,int h,int w){
    w=400;
	int i,j;
	volatile unsigned *p=(volatile unsigned *)0xBA000000+x*VGA_ROW_SIZE+y;
	for(i=0;i<h;++i){
        for(j=0;j<w;++j){
            if(p>(volatile unsigned *)0xBA096000 || p<(volatile unsigned *)0xBA000000){
                p++,img++;
                continue;
            }
            *(p++)=*(img++);
        }
		p+=VGA_ROW_SIZE-w;
	}
}

void update_bird(dir_t move){
	
}

void init_bird(){
	draw_image_2(slide1,0,0,300,400);
}

void _start() {
	disable_interrupt(&saved_c0_status);
	// init_snake();
	init_bird();
	int move_time = 200;
    int cur = 2;
	for (; ; ) {
		unsigned next_move_time = get_count_after_msec(move_time);
		dir_t move = DIR_NONE;
		while (read_c0_count() < next_move_time) {
			int c = get_key();
            if (c == 's') {
                if (cur == 1)
                    draw_image_2(slide1,0,0,300,512);
                if (cur == 2)
                    draw_image_2(slide2,0,0,300,512);
                if (cur == 3)
                    draw_image_2(slide3,0,0,300,512);
                if (cur == 4)
                    draw_image_2(slide4,0,0,300,512);
                if (cur == 5)
                    draw_image_2(slide5,0,0,300,512);
                if (cur == 6)
                    draw_image_2(slide6,0,0,300,512);
                if (cur == 7)
                    draw_image_2(slide7,0,0,300,512);
                if (cur == 8)
                    draw_image_2(slide8,0,0,300,512);
                if (cur == 9)
                    draw_image_2(slide9,0,0,300,512);
                if (cur == 10)
                    draw_image_2(slide10,0,0,300,512);
                if (cur == 11)
                    draw_image_2(slide11,0,0,300,512);
                if (cur == 12)
                    draw_image_2(slide12,0,0,300,512);
                if (cur == 13)
                    draw_image_2(slide13,0,0,300,512);
                if (cur == 14)
                    draw_image_2(slide14,0,0,300,512);
//                cur = (cur % 14) + 1;
                cur = cur + 1;
                if (cur > 14) cur = 1;
				break;
			}
            if (c == 'q')
				exit();
		}
//		update_bird(move);
		// gen_apple();
	}
}

