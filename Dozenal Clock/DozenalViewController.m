//
//  DozenalViewController.m
//  Dozenal Clock
//
//  Created by Devine Lu Linvega on 2013-01-31.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "DozenalViewController.h"
#import "DozenalViewController_WorldNode.h"

// Extras
#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

// World
NSArray			*worldPath;
NSArray			*worldAction;
NSArray			*worldDocument;
NSString        *worldNodeImg = @"empty";
NSString		*worldNodeImgId;

// User
int             userId;
NSString        *userAction;
int             userNode = 0;
int             userOrientation;
NSMutableArray	*userActionStorage;
NSString        *userActionType;
int				userActionId;

int				userSeal = 0;
int				userEnergy = 0;
int				userFold = 0;


@interface DozenalViewController ()
@end

@implementation DozenalViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	worldPath = [self worldPath];
	worldAction = [self worldAction];
	worldDocument = [self worldDocument];
	
	userActionStorage = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
	
	[self actionCheck];
    [self moveCheck];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// ====================
// Movement
// ====================

- (void)moveCheck
{
	
	self.debugNode.text = [NSString stringWithFormat:@"%d", userNode];
	self.debugOrientation.text = [NSString stringWithFormat:@"%d", userOrientation];
	self.debugAction.text = [NSString stringWithFormat:@"%@", worldPath[userNode][userOrientation]];
	
	self.moveAction.hidden = YES; [self fadeOut:_interfaceVignette t:1];
    self.moveForward.hidden = worldPath[userNode][userOrientation] ? NO : YES;
	self.moveAction.hidden = [[NSCharacterSet letterCharacterSet] characterIsMember:[worldPath[userNode][userOrientation] characterAtIndex:0]] ? NO : YES;
	
	worldNodeImgId = [NSString stringWithFormat:@"%04d", (userNode*4)+userOrientation ];
	worldNodeImg = [NSString stringWithFormat:@"%@%@%@", @"node.", worldNodeImgId, @".jpg"];
	self.viewMain.image = [UIImage imageNamed:worldNodeImg];
    
	NSLog(@"%d",[ worldPath[userNode][userOrientation] intValue]);
	
}

- (IBAction)moveLeft:(id)sender {
    
    userOrientation = userOrientation == 0 ? 3 : userOrientation-1;

	[self turnLeft];
    [self moveCheck];
    
}

- (IBAction)moveRight:(id)sender {
    
    userOrientation = userOrientation < 3 ? userOrientation+1 : 0;
    
	[self turnRight];
    [self moveCheck];
    
}

- (IBAction)moveForward:(id)sender {
	
	if ([worldPath[userNode][userOrientation] rangeOfString:@"|"].location == NSNotFound) {
		userNode = [ worldPath[userNode][userOrientation] intValue] > 0 ? [ worldPath[userNode][userOrientation] intValue] : userNode;
	} else {
		NSArray *temp = [worldPath[userNode][userOrientation] componentsSeparatedByString:@"|"];
		userNode = [ worldPath[userNode][userOrientation] intValue] > 0 ? [ temp[0] intValue] : userNode;
		userOrientation = [ temp[1] intValue ];
	}
	
	[self turnForward];
    [self moveCheck];
    
}

- (IBAction)moveAction:(id)sender {
    
    userAction = worldPath[userNode][userOrientation];
    	
    [self actionCheck];

}

- (IBAction)moveReturn:(id)sender {
    
    userAction = nil;
    
    [self actionCheck];
    [self moveCheck];
	[self actionReset];
    
}


// ====================
// Solution
// ====================

- (void)solveCheck
{
	
	self.debugAction.text = userActionStorage[userActionId];
	self.debugActionValue.text = [NSString stringWithFormat:@"%@", worldAction[userActionId]];
	[self solveRouter];
	
}

- (void)solveRouter
{
	
	if ( userActionId == 1 ) {
		[self solveAction1];
	}
	
	if ( userActionId == 2 ) {
		[self solveAction2];
	}
	
	if ( userActionId == 3 ) {
		[self solveAction3];
	}
	
	if ( userActionId == 4 ) {
		[self solveAction4];
	}
	
}

- (void)solveAction1
{
	
	if( [userActionStorage[userActionId] intValue] == 1 ){
		NSLog(@"!");
	}
	[self dimClock];
		
}


- (void)solveAction2
{
	
	if( [userActionStorage[userActionId] intValue] == 1 ){
		NSLog(@"!");
	}
	[self energyCount];
	
}




- (void)solveAction3
{
	if( userActionId == 3 && [userActionStorage[1] isEqual: worldAction[1] ] && [userActionStorage[2] isEqual: worldAction[2] ] ){
		userActionStorage[3] = @"SOLVED";
	}
	else{
		userActionStorage[3] = [NSString stringWithFormat:@"%d", [userActionStorage[3] intValue]];
	}
	
}

- (void)solveAction4
{
	
	NSLog(@"!!");
	
	[self sealCount];
	
}

// ====================
// Interactions
// ====================

- (void)actionCheck
{
    
    self.moveLeft.hidden = userAction ? YES : NO;
    self.moveRight.hidden = userAction ? YES : NO;
    self.moveForward.hidden = userAction ? YES : NO;
    self.moveReturn.hidden = userAction ? NO : YES;
    self.moveAction.hidden = userAction ? YES : NO;
	
	self.action1.hidden = YES;
	self.action2.hidden = YES;
	self.action3.hidden = YES;
	self.action4.hidden = YES;
	self.action5.hidden = YES;
	
    if( userAction ){
        
        [self actionRouting];
		[self actionTemplate];
		[self fadeIn:_interfaceVignette t:1];
		[self fadeIn:_moveReturn t:1];
		
    }
    
}

- (void)actionTemplate
{
	
	[self actionReset];
	
	if([userAction isEqual: @"act1"]){ // I. Dimensional Clock I
		
		[self.action1 setImage:[UIImage imageNamed:@"action0101.png"] forState:UIControlStateNormal];
		 self.action1.frame = CGRectMake(80, 140, 160, 160);
		[self fadeIn:self.action1 t:1];
		[self rotate:self.action1 t:2 d:( [userActionStorage[userActionId] intValue] *120 )];

		[self fadeIn:self.graphic1 t:1];
		 self.graphic1.image = [UIImage imageNamed:@"action0102.png"];
		 self.graphic1.frame = CGRectMake(80, 140, 160, 160);
		[self dimClock];
		
	}
		
	if([userAction isEqual: @"act2"]){ // Forest-Studio Door Lock
		
		self.action1.frame = CGRectMake(99, 174, 128, 128);
		[self fadeIn:self.action1 t:1];
		
		self.graphic1.image = [UIImage imageNamed:@"energy_slot0.png"];
		[self fadeIn:self.graphic1 t:0.4];
		self.graphic1.frame = CGRectMake(99, 174, 128, 128);
		
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot0.png"];
		[self fadeIn:self.graphic2 t:1.0];
		self.graphic2.frame = CGRectMake(99, 174, 128, 128);
		[self energyCount];
		
	}
	
	if([userAction isEqual: @"act3"]){ // Forest-Studio Door
		
		if( [userActionStorage[userActionId] isEqual: @"SOLVED"] ){
			[self.action3 setImage:[UIImage imageNamed:@"tempYes.png"] forState:UIControlStateNormal];
			self.action3.frame = CGRectMake(158, 220, 20, 20);
			[self fadeIn:self.action3 t:1];
		}
		else{
			self.graphic1.image = [UIImage imageNamed:@"tempNo.png"];
			[self fadeIn:self.graphic1 t:2];
			self.graphic1.frame = CGRectMake(158, 220, 20, 20);
		}
		
	}
	
	if([userAction isEqual: @"act4"]){ // Forest Seal
		
		self.action1.alpha = 0.0;
		[self.action1 setImage:[UIImage imageNamed:@"seal64_forest.png"] forState:UIControlStateNormal];
		self.action1.frame = CGRectMake(123, 190, 64, 64);
		
		if( [userActionStorage[userActionId] intValue] == 1 ){
			self.action1.alpha = 1.0;
		}
		else{
			self.action1.alpha = 0.2;
		}
		
		// Slots
		
		self.graphic1.image = [UIImage imageNamed:@"seal_slot1.png"];
		[self fadeHalf:self.graphic1 t:0.4];
		self.graphic1.frame = CGRectMake(140, 246, 16, 16);
		
		self.graphic2.image = [UIImage imageNamed:@"seal_slot1.png"];
		[self fadeHalf:self.graphic2 t:0.4];
		self.graphic2.frame = CGRectMake(152, 246, 16, 16);
		
		[self sealCount];
			
	}
	
}

- (void)actionAnimation:sender
{
	if([userAction isEqual: @"act1"]){
		[self rotate:sender t:1.0 d:( [userActionStorage[userActionId] intValue] *120 )];
	}
	
	if([userAction isEqual: @"act4"]){
		if( [userActionStorage[userActionId] intValue] == 1 ){
			[self fadeIn:sender t:0.5];
		}
		else{
			[self fadeHalf:sender t:0.5];
		}
	}
}

- (void)actionRouting
{
	
	userActionType = [userAction substringWithRange:NSMakeRange(0, 3)];
	userActionId  = [[userAction stringByReplacingOccurrencesOfString:userActionType withString:@""] intValue];
	
	if ([userAction rangeOfString:@"act"].location != NSNotFound) {
		[self solveCheck];
	}
	else if ([userAction rangeOfString:@"doc"].location != NSNotFound) {
		NSLog(@"%@", worldDocument[userActionId]);
	}

	self.action1.hidden = NO;
	self.action2.hidden = NO;
	self.action3.hidden = NO;
    	
}

- (IBAction)action1:(id)sender {
	
	// Increment
	
	userActionStorage[userActionId] = [NSString stringWithFormat:@"%d", [ userActionStorage[userActionId] intValue]+1 ];
	
	// Exceptions
	
	if([userAction isEqual: @"act1"]){	userActionStorage[userActionId] = [userActionStorage[userActionId] intValue] > 2 ? @"0" : userActionStorage[userActionId]; }
	if([userAction isEqual: @"act2"]){	userActionStorage[userActionId] = [userActionStorage[userActionId] intValue] > 4 ? @"0" : userActionStorage[userActionId]; }
	if([userAction isEqual: @"act4"]){	userActionStorage[userActionId] = [userActionStorage[userActionId] intValue] > 1 ? @"0" : userActionStorage[userActionId]; }
	
	[self actionAnimation:sender];
	[self solveCheck];
	
}

- (IBAction)action2:(id)sender {
	
	// Decrement
	
	userActionStorage[userActionId] = [NSString stringWithFormat:@"%d", [ userActionStorage[userActionId] intValue]-1 ];
	
	// Exceptions
	
	if([userAction isEqual: @"act2"]){	userActionStorage[userActionId] = [userActionStorage[userActionId] intValue] < 0 ? @"4" : userActionStorage[userActionId]; }
	
	[self solveCheck];
	
}

- (IBAction)action3:(id)sender {

	userNode = 13;
	userAction = nil;
	
	[self actionCheck];
	[self moveCheck];
	
}

- (IBAction)action4:(id)sender {
	
	[self solveCheck];
	
}

- (IBAction)action5:(id)sender {
}

- (void)actionReset
{
	
	[self.action1 setImage: nil forState: UIControlStateNormal];
	self.action1.frame = CGRectMake(170, 20, 75, 75);
	[self rotate:self.action1 t:1.0 d:0];
	[_action1 setTitle:@"" forState:UIControlStateNormal];
	
	[self.action3 setImage: nil forState: UIControlStateNormal];
	self.action3.frame = CGRectMake(170, 20, 75, 75);
	[self rotate:self.action3 t:1.0 d:0];
	
	[self fadeOut:self.graphic1 t:0];
	[self fadeOut:self.graphic2 t:0];
	[self fadeOut:self.graphic3 t:0];
	[self fadeOut:self.graphic4 t:0];
	
	[self fadeOut:self.action1 t:0];
	[self fadeOut:self.action2 t:0];
	
	
}

// ====================
// DimClock
// ====================

-(void)dimClock
{
	
	self.graphic4.frame = CGRectMake(160, 320, 32, 32);
	self.graphic3.frame = CGRectMake(130, 320, 32, 32);
	
	if( [userActionStorage[userActionId] intValue] == 0 ){
		
		[self fadeIn:self.graphic3 t:2];
		self.graphic3.image = [UIImage imageNamed:@"seal32_studio.png"];
		
		[self fadeIn:self.graphic4 t:2];
		self.graphic4.image = [UIImage imageNamed:@"seal32_antech.png"];
		
	}
	else if ( [userActionStorage[userActionId] intValue] == 1 ){
		
		[self fadeIn:self.graphic3 t:2];
		self.graphic3.image = [UIImage imageNamed:@"seal32_antech.png"];
		
		[self fadeIn:self.graphic4 t:2];
		self.graphic4.image = [UIImage imageNamed:@"seal32_stones.png"];
	
	}
	else if ( [userActionStorage[userActionId] intValue] == 2 ){
		
		[self fadeIn:self.graphic3 t:2];
		self.graphic3.image = [UIImage imageNamed:@"seal32_stones.png"];
		
		[self fadeIn:self.graphic4 t:2];
		self.graphic4.image = [UIImage imageNamed:@"seal32_studio.png"];
		
	}
	
}

- (void)sealCount
{
	
	userSeal = 0;
	
	// Check Seal Count
	if( [userActionStorage[4] intValue] == 1 ){
		userSeal += 1;
	}
	
	if( userSeal == 0 ){
		self.graphic1.image = [UIImage imageNamed:@"seal_slot1.png"];
		self.graphic2.image = [UIImage imageNamed:@"seal_slot1.png"];
	}
	else if( userSeal == 1 ){
		self.graphic1.image = [UIImage imageNamed:@"seal_slot2.png"];
		self.graphic2.image = [UIImage imageNamed:@"seal_slot1.png"];
	}
	else if( userSeal == 2 ){
		self.graphic1.image = [UIImage imageNamed:@"seal_slot2.png"];
		self.graphic2.image = [UIImage imageNamed:@"seal_slot2.png"];
	}
	else{
		self.graphic1.image = [UIImage imageNamed:@"seal_slot2.png"];
		self.graphic2.image = [UIImage imageNamed:@"seal_slot2.png"];
	}

}

- (void)energyCount
{

	userEnergy = [userActionStorage[2] intValue];
	
	self.graphic2.alpha = 1.0;
	
	// Check Seal Count
	if( userEnergy == 0 ){
		self.graphic1.image = [UIImage imageNamed:@"energy_slot0.png"];
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot4.png"];
		
	}
	if( userEnergy == 1 ){
		self.graphic1.image = [UIImage imageNamed:@"energy_slot1.png"];
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot3.png"];
	}
	if( userEnergy == 2 ){
		self.graphic1.image = [UIImage imageNamed:@"energy_slot2.png"];
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot2.png"];
	}
	if( userEnergy == 3 ){
		self.graphic1.image = [UIImage imageNamed:@"energy_slot3.png"];
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot1.png"];
	}
	if( userEnergy == 4 ){
		self.graphic1.image = [UIImage imageNamed:@"energy_slot4.png"];
		self.graphic2.image = [UIImage imageNamed:@"energy_userslot0.png"];
		self.graphic2.alpha = 0.3;
	}
	
}

// ====================
// Tools
// ====================

-(void)fadeIn:(UIView*)viewToFadeIn t:(NSTimeInterval)duration
{
	[UIView beginAnimations: @"Fade In" context:nil];
	[UIView setAnimationDuration:duration];
	viewToFadeIn.alpha = 1;
	[UIView commitAnimations];
}

-(void)fadeOut:(UIView*)viewToFadeOut t:(NSTimeInterval)duration
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDuration:duration];
	viewToFadeOut.alpha = 0;
	[UIView commitAnimations];
}
-(void)fadeHalf:(UIView*)viewToFadeOut t:(NSTimeInterval)duration
{
	[UIView beginAnimations: @"Fade Half" context:nil];
	[UIView setAnimationDuration:duration];
	viewToFadeOut.alpha = 0.2;
	[UIView commitAnimations];
}
- (void)rotate:(UIButton *)viewToRotate t:(NSTimeInterval)duration d:(CGFloat)degrees
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationBeginsFromCurrentState:YES];
	CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
	viewToRotate.transform = transform;
	[UIView commitAnimations];
}

-(void)turnLeft
{
	self.viewMain.alpha = 0.5;
	self.viewMain.transform = CGAffineTransformMakeTranslation(-10, 0);
	
	[UIView beginAnimations: @"Turn Left" context:nil];
	[UIView setAnimationDuration:0.2];
	self.viewMain.transform = CGAffineTransformMakeTranslation(0, 0);
	self.viewMain.alpha = 1;
	[UIView commitAnimations];
}

-(void)turnRight
{
	self.viewMain.alpha = 0.5;
	self.viewMain.transform = CGAffineTransformMakeTranslation(10, 0);
	
	[UIView beginAnimations: @"Turn Right" context:nil];
	[UIView setAnimationDuration:0.2];
	self.viewMain.transform = CGAffineTransformMakeTranslation(0, 0);
	self.viewMain.alpha = 1;
	[UIView commitAnimations];
}

-(void)turnForward
{
	self.viewMain.alpha = 0.5;
	self.viewMain.transform = CGAffineTransformMakeTranslation(0, 2);
	
	[UIView beginAnimations: @"Turn Right" context:nil];
	[UIView setAnimationDuration:0.2];
	self.viewMain.transform = CGAffineTransformMakeTranslation(0, 0);
	self.viewMain.alpha = 1;
	[UIView commitAnimations];
}

@end