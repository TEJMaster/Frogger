#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Xiangyu Tu, Student Number 1006768794
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Add a third row in each of the water and road sections. OK
# 2. Have objects in different rows move at different speeds. OK
# 3. Make objects (frog, logs, turtles, vehicles, etc) look more like the arcade version. OK
# 4. Display the number of lives remaining. OK
# 5. After final player death, display game over/retry screen. Restart the game if the “retry” option is chosen. OK
# 6. Add sound effects for movement, losing lives, collisions, and reaching the goal. OK
# 7. Display a death/respawn animation each time the player loses a frog. OK
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################	
.data
displayAddress: .word 0x10008000
screen_width: .word 128
screenMax: .word 0x10008f00

safe_colour: .word 0x800080
road_colour: .word 0x888888
water_colour: .word 0x0000FF
goal_colour: .word 0x00FF00
heart_colour: .word 0xFFC0CB
blood_colour: .word 0xAC0404
blood_colour2: .word 0x75FCFC

#############################################
# background variables
goal_width: .word 5
goal_height: .word 5
goal_row: .word 0x10008180
goal_colour0: .word 0x0000FF

goal_column1: .word 0x10
goal_colour1: .word 0x0000FF
goal_column2: .word 0x38
goal_colour2: .word 0x0000FF
goal_column3: .word 0x60
goal_colour3: .word 0x0000FF

################################################
# frog variables
frog_row0: .word 0x10008e80
frog_column0: .word 0x44
frog_row: .word 0x10008e80
frog_column: .word 0x44
frog_colour: .word 0xFFFF00
frog_hight: .word 3
frog_width: .word 3
frog_speed: .word 3
livestatus: .word 1
life: .word 3
################################################
# car variables
car_height:.word 3
car_width: .word 4
car_colour: .word 0xFF0000
car_tire_colour: .word 0x3A3A3A
car_tire_colour2: .word 0xB491C8

car1_row: .word 0x10008d00
car1_column: .word 0x04
car1_speed: .word 4

car2_row: .word 0x10008d00
car2_column: .word 0x40
car2_speed: .word 4
car2_width: .word 6

car3_row: .word 0x10008a00
car3_column: .word 0x20
car3_speed: .word 8

car4_row: .word 0x10008a00
car4_column: .word 0x100
car4_speed: .word 8

car5_row: .word 0x10008b80
car5_column: .word 0x120
car5_width: .word 8
car5_speed: .word -4
car5_colour: .word 0xf39539

#################################
# wood variables
wood_colour: .word 0xA52A2A
wood_colour2: .word 0x567d46
wood_height:.word 3

wood1_width: .word 8
wood1_row: .word 0x10008700
wood1_column: .word 0x04
wood1_speed: .word 4

wood2_width: .word 7
wood2_row: .word 0x10008700
wood2_column: .word 0x48
wood2_speed: .word 4

wood3_width: .word 6
wood3_row: .word 0x10008580
wood3_column: .word 0x04
wood3_speed: .word -4

wood4_width: .word 8
wood4_row: .word 0x10008580
wood4_column: .word 0x40
wood4_speed: .word -4

wood5_width: .word 8
wood5_row: .word 0x10008400
wood5_column: .word 0x04
wood5_speed: .word 4

wood6_width: .word 8
wood6_row: .word 0x10008400
wood6_column: .word 0x44
wood6_speed: .word 4

.text

main:

jal draw_background
lw $a2 life
bge $a2 1 draw_heart1
m:
bge $a2 2 draw_heart2
m1:
bge $a2 3 draw_heart3
m2:

jal draw_goal1
jal draw_goal2
jal draw_goal3

jal draw_car1
jal draw_car2
jal draw_car3
jal draw_car4
jal draw_car5


jal draw_wood1
jal draw_wood2
jal draw_wood3
jal draw_wood4
jal draw_wood5
jal draw_wood6


jal move_frog
jal draw_frog


jal check_car1
jal check_car2
jal check_car3
jal check_car4
jal check_car5


lw $a0 frog_row
lw $a1 displayAddress
addi $a1 $a1 2176
blt $a0 $a1 check_in_water



li, $v0, 32
li $a0, 1000
syscall
j main

##########################################
# functions
#########################################
check_in_water:
	# check whether the frog is in the water region
	jal check_wood1
	beq $v0 1 move_right
	jal check_wood2
	beq $v0 1 move_right
	jal check_wood3
	beq $v0 1 move_left
	jal check_wood4
	beq $v0 1 move_left
	jal check_wood5
	beq $v0 1 move_right
	jal check_wood6
	beq $v0 1 move_right
	jal check_goal1
	jal check_goal2
	jal check_goal3
	# if the frog is not colliding with any of the wood or goals set it to death
	jal set_death
	jr $ra

##########################################
# functions to draw woods
draw_wood1:
	add $t7 $ra $zero
	lw $t4 wood1_row
	lw $t5 wood1_column
	lw $t9 wood1_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood1_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood1_width
	lw $a3 wood_colour
	jal draw_rectangle
	jr $t7

draw_wood2:
	add $t7 $ra $zero
	lw $t4 wood2_row
	lw $t5 wood2_column
	lw $t9 wood2_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood2_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood2_width
	lw $a3 wood_colour
	jal draw_rectangle
	jr $t7

draw_wood3:
	add $t7 $ra $zero
	lw $t4 wood3_row
	lw $t5 wood3_column
	lw $t9 wood3_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood3_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood3_width
	lw $a3 wood_colour2
	jal draw_rectangle
	jr $t7

draw_wood4:
	add $t7 $ra $zero
	lw $t4 wood4_row
	lw $t5 wood4_column
	lw $t9 wood4_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood4_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood4_width
	lw $a3 wood_colour2
	jal draw_rectangle
	jr $t7
	
draw_wood5:
	add $t7 $ra $zero
	lw $t4 wood5_row
	lw $t5 wood5_column
	lw $t9 wood5_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood5_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood5_width
	lw $a3 wood_colour
	jal draw_rectangle
	jr $t7

draw_wood6:
	add $t7 $ra $zero
	lw $t4 wood6_row
	lw $t5 wood6_column
	lw $t9 wood6_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 wood6_column
	add $a0 $t4 $t5
	lw $a1 wood_height
	lw $a2 wood6_width
	lw $a3 wood_colour
	jal draw_rectangle
	jr $t7
# check collision with the woods

check_wood1:
	add $t6 $ra $zero
	lw $a0 wood1_row
	lw $a1 wood_height
	lw $a2 wood1_column
	lw $a3 wood1_width
	jal check_collision
	jr $t6
	
check_wood2:
	add $t6 $ra $zero
	lw $a0 wood2_row
	lw $a1 wood_height
	lw $a2 wood2_column
	lw $a3 wood2_width
	jal check_collision
	jr $t6

check_wood3:
	add $t6 $ra $zero
	lw $a0 wood3_row
	lw $a1 wood_height
	lw $a2 wood3_column
	lw $a3 wood3_width
	jal check_collision
	jr $t6

check_wood4:
	add $t6 $ra $zero
	lw $a0 wood4_row
	lw $a1 wood_height
	lw $a2 wood4_column
	lw $a3 wood4_width
	jal check_collision
	jr $t6

check_wood5:
	add $t6 $ra $zero
	lw $a0 wood5_row
	lw $a1 wood_height
	lw $a2 wood5_column
	lw $a3 wood5_width
	jal check_collision
	jr $t6

check_wood6:
	add $t6 $ra $zero
	lw $a0 wood6_row
	lw $a1 wood_height
	lw $a2 wood6_column
	lw $a3 wood6_width
	jal check_collision
	jr $t6
	
# move the frog right with the logs travel right
move_right:
	lw $a0 frog_column 
	addi $a0 $a0 4
	bge $a0 120 stop_move
	sw $a0 frog_column
	li, $v0, 32
	li $a0, 1000
	syscall
	j main
# move the frog left with the logs travel left
move_left:
	lw $a0 frog_column 
	addi $a0 $a0 -4
	ble $a0 4 stop_move
	sw $a0 frog_column
	li, $v0, 32
	li $a0, 1000
	syscall
	j main
# stop moving when it reaches the edges
stop_move:
	li, $v0, 32
	li $a0, 1000
	syscall
	jr $t6

##########################################
# car functions

# functions to draw cars
draw_car1:
	add $t7 $ra $zero
	lw $t4 car1_row
	lw $t5 car1_column
	lw $t9 car1_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 car1_column
	add $a0 $t4 $t5
	lw $a1 car_height
	lw $a2 car_width
	lw $a3 car_colour
	jal draw_rectangle
	lw $t1 car_tire_colour
	sw $t1 0($a0)
	sw $t1 256($a0)
	jr $t7

draw_car2:
	add $t7 $ra $zero
	lw $t4 car2_row
	lw $t5 car2_column
	lw $t9 car2_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 car2_column
	add $a0 $t4 $t5
	lw $a1 car_height
	lw $a2 car2_width
	lw $a3 car_colour
	jal draw_rectangle
	lw $t1 car_tire_colour
	sw $t1 0($a0)
	sw $t1 256($a0)
	jr $t7

draw_car3:
	add $t7 $ra $zero
	lw $t4 car3_row
	lw $t5 car3_column
	lw $t9 car3_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 car3_column
	add $a0 $t4 $t5
	lw $a1 car_height
	lw $a2 car_width
	lw $a3 car_colour
	jal draw_rectangle
	lw $t1 car_tire_colour
	sw $t1 0($a0)
	sw $t1 256($a0)
	jr $t7

draw_car4:
	add $t7 $ra $zero
	lw $t4 car4_row
	lw $t5 car4_column
	lw $t9 car4_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 car4_column
	add $a0 $t4 $t5
	lw $a1 car_height
	lw $a2 car_width
	lw $a3 car_colour
	jal draw_rectangle
	lw $t1 car_tire_colour
	sw $t1 0($a0)
	sw $t1 256($a0)
	jr $t7

draw_car5:
	add $t7 $ra $zero
	lw $t4 car5_row
	lw $t5 car5_column
	lw $t9 car5_speed
	add $t5 $t5 $t9
	lw $t8 screen_width
	add $t5 $t8 $t5
	div $t5 $t8
	mfhi $t5
	sw $t5 car5_column
	add $a0 $t4 $t5
	lw $a1 car_height
	lw $a2 car5_width
	lw $a3 car5_colour
	jal draw_rectangle
	lw $t1 car_tire_colour2
	sw $t1 128($a0)
	jr $t7

# functions to check collision with the cars
check_car1:
	add $t6 $ra $zero
	lw $a0 car1_row
	lw $a1 car_height
	lw $a2 car1_column
	lw $a3 car_width
	jal check_collision
	beq $v0 1 set_death
	jr $t6

check_car2:
	add $t6 $ra $zero
	lw $a0 car2_row
	lw $a1 car_height
	lw $a2 car2_column
	lw $a3 car2_width
	jal check_collision
	beq $v0 1 set_death
	jr $t6
	
check_car3:
	add $t6 $ra $zero
	lw $a0 car3_row
	lw $a1 car_height
	lw $a2 car3_column
	lw $a3 car_width
	jal check_collision
	beq $v0 1 set_death
	jr $t6

check_car4:
	add $t6 $ra $zero
	lw $a0 car4_row
	lw $a1 car_height
	lw $a2 car4_column
	lw $a3 car_width
	jal check_collision
	beq $v0 1 set_death
	jr $t6

check_car5:
	add $t6 $ra $zero
	lw $a0 car5_row
	lw $a1 car_height
	lw $a2 car5_column
	lw $a3 car5_width
	jal check_collision
	beq $v0 1 set_death
	jr $t6

# the the frog to death when hit by a car or is in water	
set_death:
	lw $t1 frog_row
	lw $t2 frog_column
	add $a1 $t1 $t2
	lw $a2 blood_colour
	lw $a3 blood_colour2
	# display a death animation
	sw $a2 0($a1)
	sw $a3 4($a1)
	sw $a2 8($a1)
	addi $a1 $a1 128
	sw $a3 0($a1)
	sw $a3 4($a1)
	sw $a3 8($a1)
	addi $a1 $a1 128
	sw $a3 0($a1)
	sw $a2 4($a1)
	sw $a3 8($a1)
	addi $a1 $a1 128
	sw $a2 8($a1)
	sw $a2 12($a1)
	sw $a2 16($a1)
	li $a0, 75 # death sound
	li $a1, 1000 
   	li $a2, 89
    	li $a3, 50 
	li $v0, 31 
	syscall
	# delay for 2 seconds
	li, $v0, 32
	li $a0, 2000
	syscall
	lw $a0 life
	subi $a0 $a0 1
	sw $a0 life
	# life minus 1 if life is still greater than 0 reset the frog 
	bgt $a0 $zero reset_frog
	# else the game is over
	jal end

reset_frog:
	# reset the column and row for the frog to the beginning, display a sound effect
	lw $a0 frog_row0
	sw $a0 frog_row
	lw $a0 frog_column0
	sw $a0 frog_column
	li $a0, 50 # reset sound
	li $a1, 1000 
   	li $a2, 100 
    	li $a3, 68 
	li $v0, 31
	syscall
	j main

end:
	li $a0, 70 # sound for end
	li $a1, 1500 
   	li $a2, 8
    	li $a3, 64 
	li $v0, 31
	syscall
	# draw R to the top left
	lw $a0 displayAddress
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 8($a0)
	sw $zero 12($a0)
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 16($a0)
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 16($a0)
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 8($a0)
	sw $zero 12($a0)
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 16($a0)
	addi $a0 $a0 128
	sw $zero 4($a0)
	sw $zero 20($a0)
finnishd_r:
	# check keyboard input is equal to r reset the game
	lw $s1, 0xffff0000
	beq $s1, 1, check_r
	li, $v0, 32
	li $a0, 1000
	syscall
	
	j finnishd_r
check_r:
	lw $s2 0xffff0004
	beq $s2, 0x52, respond_to_R
	
	

respond_to_R:
	# play a sound effect for restart
	li $a0, 70 # sound to restart
	li $a1, 1000 
   	li $a2, 50
    	li $a3, 70 
	li $v0, 31
	syscall
	# reset the frog position the life and the goal region
	lw $a0 frog_row0
	sw $a0 frog_row
	lw $a0 frog_column0
	sw $a0 frog_column
	lw $a0 goal_colour0
	sw $a0 goal_colour1
	sw $a0 goal_colour2
	sw $a0 goal_colour3
	
	addi $a0 $zero 3
	sw $a0 life
	
	syscall
	j main

##########################################
# world functions
# This will draw the background
draw_background:	
		add $t4, $zero, $t0    
		add $t5, $zero, $zero   
		add $t7 $ra $zero
destination:  	
		lw $a0 displayAddress
		addi $a2 $zero 32
		addi $a1 $zero 8
		lw $a3 goal_colour
		jal draw_rectangle

water_region:	
		lw $a0 displayAddress
		addi $a0 $a0 1024
		addi $a2 $zero 32
		addi $a1 $zero 9
		lw $a3 water_colour
		jal draw_rectangle
		

safe_region: 	
		lw $a0 displayAddress
		addi $a0 $a0 2176
		addi $a2 $zero 32
		addi $a1 $zero 3
		lw $a3 safe_colour
		jal draw_rectangle
		
road_region: 	
		lw $a0 displayAddress
		addi $a0 $a0 2560
		addi $a2 $zero 32
		addi $a1 $zero 9
		lw $a3 road_colour
		jal draw_rectangle


start_region:  
		lw $a0 displayAddress
		addi $a0 $a0 3712
		addi $a2 $zero 32
		addi $a1 $zero 3
		lw $a3 safe_colour
		jal draw_rectangle 
		
return:		
		jr $t7
		
##################################################
#frog functions
draw_frog:
	add $t7 $ra $zero
	lw $t4 frog_row
	lw $t5 frog_column
	add $a0 $t4 $t5
	lw $a1 frog_hight
	lw $a2 frog_width
	lw $a3 frog_colour
	sw $zero 0($a0)
	sw $a3 4($a0)
	sw $zero 8($a0)
	addi $a0 $a0 128
	sw $a3 0($a0)
	sw $a3 4($a0)
	sw $a3 8($a0)
	addi $a0 $a0 128
	sw $a3 0($a0)
	sw $a3 8($a0)
	jr $t7


move_frog:	
	lw $s1, 0xffff0000
	beq $s1, 1, keyboard_input
	# check keyboard_input
	j Exit

keyboard_input:
	lw $t0 screen_width
	lw $t2, 0xffff0004
	beq $t2, 0x61, respond_to_A
	beq $t2, 0x77, respond_to_W
	beq $t2, 0x73, respond_to_S
	beq $t2, 0x64, respond_to_D

respond_to_A:
	# frog go left
	li $a0, 70 # sound to jump
	li $a1, 4000 
   	li $a2, 115
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $t0 frog_column
	lw $t1 frog_speed
	addi $t2 $zero 4
	mul $t1 $t1 $t2
	sub $t0 $t0 $t1
	blez $t0 A
	sw $t0 frog_column
	A:
	jr $ra

respond_to_W:
	# frog go up
	li $a0, 70 # sound to jump
	li $a1, 4000 
   	li $a2, 115
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $t0 frog_row 
	lw $t1 frog_speed 
	lw $t3 screen_width 
	lw $t4 displayAddress 
	mul $t1 $t3 $t1 
	sub $t0 $t0 $t1 
	blt $t0 $t4 W 
	sw $t0 frog_row
	W:
	jr $ra

respond_to_S:
	# frog go down
	li $a0, 70 # sound to jump
	li $a1, 4000 
   	li $a2, 115 
   	li $a3, 64 
	li $v0, 31
	syscall
	lw $t0 frog_row
	lw $t1 frog_speed
	lw $t3 screen_width
	lw $t4 screenMax
	mul $t1 $t3 $t1
	add $t0 $t0 $t1
	bge $t0 $t4 S
	sw $t0 frog_row
	S:
	jr $ra

respond_to_D:
	# frog go right
	li $a0, 70 # sound to jump
	li $a1, 4000 
   	li $a2, 115 
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $t0 frog_column
	lw $t1 frog_speed
	addi $t2 $zero 4
	mul $t1 $t1 $t2
	lw $t3 screen_width
	add $t0 $t0 $t1
	bge $t0 $t3 D
	sw $t0 frog_column
	D:
	jr $ra

Exit:
	jr $ra

#################################################
# helper function to draw a rectangle given position, width, height, colour
draw_rectangle:
	lw $s3 displayAddress
	lw $t0 screen_width
	add $t5 $zero $zero
	add $t3 $a0 $zero	# a0 stores the position
	sub $s3 $a0 $t7		
	div $a0 $t0
	mfhi $s3
	sub $s3 $t0 $s3


draw_rect:
	bge $t5 $a1 exit_rectangle	# a1 stores the height
				# finnishished after it reaches height
	add $t1 $zero $zero 
	add $t2 $zero $zero 

draw_line:
	bge $t1 $a2 exit_draw_line	# a2 stores the width
	add $t4 $t2 $t3			# go to next line when it reaches width
	blt $t2 $s3 q
	sub $t4 $t4 $t0

q:
	sw $a3 0($t4)			# a3 storesx the colour
	addi $t2 $t2 4
	addi $t1 $t1 1
	j draw_line 

exit_draw_line:
	add $t3 $t3 $t0
	addi $t5 $t5 1
	j draw_rect

exit_rectangle:
	jr $ra

###################################################
check_collision:
		add $s0 $ra $zero 
		add $s4 $a0 $zero # row
		add $s5 $a1 $zero # height
		add $s6 $a2 $zero # column
		add $s7 $a3 $zero # width
		# stores the object's 4 courners
		jal to_blocks
		add $a2 $v0 $zero # a2 stroes the row at the top
		add $a3 $a2 $s5   # a3 stores the row at the bottom
		lw $a0 frog_row   
		jal to_blocks     
		add $a0 $v0 $zero  # a0 now stores the row of the frog top
		lw $t0 frog_hight 
		add $a1 $a0 $t0    # a1 now stores the row of the frog bottom
		jal compare_line
		beq $v0 $zero finnish
		# now check column
		addi $t1 $zero 4
		mul $s7 $s7 $t1 # s7 stores 4 times the width
		add $a0 $s6 $zero # a0 now stores the object's column at the left
		add $a1 $a0 $s7   # a1 now stores the object's column at the right
		lw $a2 frog_column # a2 is the frog column at the left
		lw $t0 frog_width
		mul $t0 $t0 $t1
		add $a3 $a2 $t0  # a3 is the frog column at the right
		
		jal compare_line
		beq $v0 $zero finnish
		
		addi $v0 $zero 1
		jr $s0
		
finnish:
	add $v0 $zero $zero
	jr $s0

to_blocks:
	lw $t1 displayAddress
	sub $t0 $a0 $t1 
	lw $t2 screen_width
	div $v0 $t0 $t2 
	jr $ra

compare_line:
	bge $a0 $a3 f 
	bge $a2 $a1 f 
	addi $v0 $zero 1
	jr $ra
	f:
	add $v0 $zero $zero
	jr $ra
######################################### 
# draw hearts at the top right

draw_heart1:

	lw $a0 displayAddress
	addi $a0 $a0 248
	lw $a1 heart_colour
	sw $a1 0($a0)
	j m

draw_heart2:
	lw $a0 displayAddress
	addi $a0 $a0 240
	lw $a1 heart_colour
	sw $a1 0($a0)
	j m1

draw_heart3:
	lw $a0 displayAddress
	addi $a0 $a0 232
	lw $a1 heart_colour
	sw $a1 0($a0)
	j m2
#########################################
# goal funcitons
draw_goal1:
	add $t7 $ra $zero
	lw $t4 goal_row
	lw $t5 goal_column1
	add $a0 $t4 $t5
	lw $a1 goal_height
	lw $a2 goal_width
	lw $a3 goal_colour1
	jal draw_rectangle
	jr $t7

draw_goal2:
	add $t7 $ra $zero
	lw $t4 goal_row
	lw $t5 goal_column2
	add $a0 $t4 $t5
	lw $a1 goal_height
	lw $a2 goal_width
	lw $a3 goal_colour2
	jal draw_rectangle
	jr $t7

draw_goal3:
	add $t7 $ra $zero
	lw $t4 goal_row
	lw $t5 goal_column3
	add $a0 $t4 $t5
	lw $a1 goal_height
	lw $a2 goal_width
	lw $a3 goal_colour3
	jal draw_rectangle
	jr $t7
	
check_goal1:
	add $t6 $ra $zero
	lw $a0 goal_row
	lw $a1 goal_height
	lw $a2 goal_column1
	lw $a3 goal_width
	jal check_collision
	beq $v0 1 set_goal1
	jr $t6

set_goal1:
	lw $a0 goal_colour1
	lw $a1 frog_colour
	beq $a0 $a1 set_death
	# set goal 1 to yellow and reset frog 
	li $a0, 72 # sound to goal
	li $a1, 2000
   	li $a2, 120
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $a0 frog_colour
	sw $a0 goal_colour1
	jal reset_frog
	syscall
	jr $t6
	
check_goal2:
	add $t6 $ra $zero
	lw $a0 goal_row
	lw $a1 goal_height
	lw $a2 goal_column2
	lw $a3 goal_width
	jal check_collision
	beq $v0 1 set_goal2
	jr $t6

set_goal2:
	lw $a0 goal_colour2
	lw $a1 frog_colour
	beq $a0 $a1 set_death
	# set goal 2 to yellow and reset frog 
	li $a0, 72 # sound to goal
	li $a1, 2000
   	li $a2, 120
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $a0 frog_colour
	sw $a0 goal_colour2
	jal reset_frog
	jr $t6

check_goal3:
	add $t6 $ra $zero
	lw $a0 goal_row
	lw $a1 goal_height
	lw $a2 goal_column3
	lw $a3 goal_width
	jal check_collision
	beq $v0 1 set_goal3
	jr $t6

set_goal3:
	lw $a0 goal_colour3
	lw $a1 frog_colour
	beq $a0 $a1 set_death
	# set goal 3 to yellow and reset frog 
	li $a0, 72 # sound to goal
	li $a1, 2000
   	li $a2, 120
    	li $a3, 64 
	li $v0, 31
	syscall
	lw $a0 frog_colour
	sw $a0 goal_colour3
	jal reset_frog
	jr $t6

######################################### EOF