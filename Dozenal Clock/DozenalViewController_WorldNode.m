#import "DozenalViewController_WorldNode.h"

@implementation DozenalViewController (Math)


-(NSMutableArray*) worldPath
{
	
	NSMutableArray *node = [NSMutableArray arrayWithObjects:@"",nil];
	
	// ====================
	// Forest ( 0 - 11 )
	// ====================	

	node[0]		= [NSArray arrayWithObjects: @"1", @"e", @"0", @"0", nil];
	node[1]		= [NSArray arrayWithObjects: @"2", @"0", @"0", @"0", nil];
	node[2]		= [NSArray arrayWithObjects: @"3", @"0", @"1", @"0", nil];
	node[3]		= [NSArray arrayWithObjects: @"11", @"10", @"2", @"4", nil];
	node[4]		= [NSArray arrayWithObjects: @"5", @"3", @"0", @"0", nil];
	node[5]		= [NSArray arrayWithObjects: @"6", @"0", @"4", @"0", nil];
	node[6]		= [NSArray arrayWithObjects: @"0", @"7", @"5", @"0", nil];
	node[7]		= [NSArray arrayWithObjects: @"0", @"8", @"0", @"6", nil];
	node[8]		= [NSArray arrayWithObjects: @"0", @"0", @"9", @"7", nil];
	node[9]		= [NSArray arrayWithObjects: @"8", @"0", @"10", @"0", nil];
	node[10]	= [NSArray arrayWithObjects: @"9", @"0", @"0", @"3", nil];
	node[11]	= [NSArray arrayWithObjects: @"0", @"0", @"3", @"0", nil];
	
	return node;
}

- (NSMutableArray*) worldAction
{
	
	NSMutableArray *puzzle = [NSMutableArray arrayWithObjects:@"",nil];
	
	// ====================
	// Forest ( 1 - 3 )
	// ====================
	
	puzzle[0]		= [NSArray arrayWithObjects: @"First Puzzle", @"Solution", @"State", nil];
	puzzle[1]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[2]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[3]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[4]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[5]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[6]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[7]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[8]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[9]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[10]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	puzzle[11]		= [NSArray arrayWithObjects: @"Name", @"Solution", @"State", nil];
	
	return puzzle;
}


@end