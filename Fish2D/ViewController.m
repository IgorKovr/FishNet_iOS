//
//  ViewController.m
//  Fish2D
//
//  Created by Igor Kovrizhkin on 4/26/13.
//  Copyright (c) 2013 kovrizhkin. All rights reserved.

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "DragDot.h"

#define gukKoef  0.5
#define DotMass 3
#define iterations   5
#define timerFrequency 30 //Hz
#define indent 20

@interface ViewController () {
    float GravityX;
    float GravityY;
    BOOL  isVisible;
}

@property NSTimer *myTimer;
@property CMMotionManager *motionManager;
@property NSMutableArray *DragDotsArray;
@property NSMutableArray *StaticDotsArray;
@property UITapGestureRecognizer *doubleTapGesture;
@property DragDot *lastTouchedDot;
@end

@implementation ViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / timerFrequency target:self selector:@selector(deformation) userInfo:nil repeats:YES];
    self.drawView->spread = (([self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation].width - indent * 2) / XDots) / 2.5;
    [self initDotNetToOrientation: [UIApplication sharedApplication].statusBarOrientation];
    
    self->isVisible = true;
    self.DragDotsArray = [NSMutableArray array];
    self.StaticDotsArray = [NSMutableArray array];
    DragDot *dragdot = [DragDot new];
    dragdot.x=0;
    dragdot.y=0;
    [self.StaticDotsArray addObject:dragdot];
    dragdot = nil;
    dragdot = [DragDot new];
    dragdot.x=0;
    dragdot.y= YDots - 1;
    [self.StaticDotsArray addObject:dragdot];
    // Motion Manager for Gravity Detection
    _motionManager = [[CMMotionManager alloc] init];
    if (_motionManager.isAccelerometerAvailable){
        _motionManager.accelerometerUpdateInterval = 1.0 / timerFrequency;
    }
    [_motionManager startAccelerometerUpdates];
    // TapRegognizer for DoubleTap
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.doubleTapGesture];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^ {
        [self initDotNetToOrientation:toInterfaceOrientation];
    }];
}

- (void)initDotNetToOrientation:(UIInterfaceOrientation)orientation{
    CGPoint origin;
    origin.x = [self getScreenFrameForOrientation:orientation].width / 2 - self.drawView->spread * XDots/2;
    origin.y = [self getScreenFrameForOrientation:orientation].height / 2 - self.drawView->spread * YDots/2;
    for(int i=0;i<YDots;i++)
		for(int k=0;k<XDots;k++){
			self.drawView->g_DotNet[i][k].x=origin.x + self.drawView->spread*k;  // initial position of Dots in Net
			self.drawView->g_DotNet[i][k].y=self.drawView->spread+i*5;//origin.y + spread*i;
		}
    // Move first and last dot to the top
    self.drawView->g_DotNet[0][XDots-1].y = self.drawView->spread;
    self.drawView->g_DotNet[0][0].y = self.drawView->spread;
    self.drawView->g_DotNet[0][XDots-1].x = [self getScreenFrameForOrientation:orientation].width-self.drawView->spread;
    self.drawView->g_DotNet[0][0].x = self.drawView->spread;
}

- (CGSize)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

#pragma mark - TouchEvents

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        
        BOOL remove = false;
        for (int i = [self.StaticDotsArray count] - 1.0; i >= 0; i--) {
            DragDot *dot = [self.StaticDotsArray objectAtIndex:i];
            if ((dot.x == self.lastTouchedDot.x) && (dot.y == self.lastTouchedDot.y))
            {
                [self.StaticDotsArray removeObject:dot];
                i--;
                remove = true;
            }
        }
      if (!remove)
          [self.StaticDotsArray addObject:self.lastTouchedDot];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches){       
        DragDot *Dragdot = [self findNearestDotToPoint:[touch locationInView:self.view]];
        if (Dragdot) {
            Dragdot.touch = touch;
            [self.DragDotsArray addObject:Dragdot];
            self.lastTouchedDot = Dragdot;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches){
        for (DragDot *Dragdot in self.DragDotsArray) {
            if (Dragdot.touch==touch)
                [self dragDot:Dragdot toPoint:[touch locationInView:self.view]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent*)event {
    NSLog(@"touchesCount: %lu",(unsigned long)[touches count]);
    for (UITouch *curTouch in touches) {
        for (int i = [self.DragDotsArray count] - 1.0; i>=0; i--) {
            DragDot *Dragdot = [self.DragDotsArray objectAtIndex:i];
            if (curTouch == Dragdot.touch){
                [self.DragDotsArray removeObject:Dragdot];
                i--;
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
     [self.DragDotsArray removeAllObjects];
}

- (void)dragDot:(DragDot *)dot toPoint:(CGPoint)point {
    int y, x;
    y = dot.y;     //self.drawView->DraggedDotIndexY;
    x = dot.x;     //self.drawView->DraggedDotIndexX;
    self.drawView->g_DotNet[x][y].x=point.x;
    self.drawView->g_DotNet[x][y].y=point.y;
}

- (DragDot *)findNearestDotToPoint:(CGPoint)point {
    DragDot *dot = [DragDot new];
    dot.x = XDots+1;
    dot.y = YDots+1;
    
	float smallest;
	for(int i=0;i<YDots;i++)
		for(int k=0;k<XDots;k++){
			smallest=fabs(self.drawView->g_DotNet[k][i].x - point.x) + fabs(self.drawView->g_DotNet[k][i].y - point.y); // Distance bewen Dots and cursor
			if (fabs(smallest) < self.drawView->spread) {  // if Distance less then spread - Grab that Dot
				dot.y=i; //!!
				dot.x=k;
				i=YDots;
				break;
			}
		}
    if ((dot.y == YDots+1) || (dot.x == XDots+1)) return nil;
    return dot;
}

#pragma mark - Calculations

- (CGPoint)elementaryForseBetwen:(CGPoint)point1 and:(CGPoint)point2 {     // Function Calculates force between two Dots
	CGFloat dY, dX, D, dD;
	dY= point1.y - point2.y;
	dX= point1.x - point2.x;
	D=sqrt(dY*dY+dX*dX);      // distance between Dots
	dD=(D-self.drawView->spread);              // tension
	if (dD<=0) return CGPointZero; // if no tension return {0, 0}
	else{
        CGPoint forse;
		forse.x =   - (dX/D)*dD*gukKoef;     // dF.x= cos(Alpha)*tension*Guk_koef
		forse.y =   - (dY/D)*dD*gukKoef;     // dF.y= sin(Alpha)*tension*Guk_koef
		return forse;
	}
}

- (CGPoint)addForses: (CGPoint)forse1 and:(CGPoint)forse2{  // Adds forse2 to forse1
    (forse1).x=(forse1).x+(forse2).x;
    (forse1).y=(forse1).y+(forse2).y;
    return forse1;
}

- (double)gravityY{
    if (_motionManager.isAccelerometerAvailable){
    CMAccelerometerData *newestAccel = _motionManager.accelerometerData;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    double gravityY = 0.0;
        if(orientation == 0) //Default orientation
            gravityY = newestAccel.acceleration.y;
            else if(orientation == UIInterfaceOrientationPortrait)
                gravityY = newestAccel.acceleration.y;
                else if(orientation == UIInterfaceOrientationLandscapeLeft)
                    gravityY = -newestAccel.acceleration.x;
                    else if(orientation == UIInterfaceOrientationLandscapeRight)
                       gravityY = newestAccel.acceleration.x;
                         else gravityY = -newestAccel.acceleration.y;
    return gravityY;
    } else
       return -1;
}

- (double)gravityX{
    if (_motionManager.isAccelerometerAvailable){
    CMAccelerometerData *newestAccel = _motionManager.accelerometerData;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    double gravityX = 0.0;
        
        if(orientation == 0) //Default orientation
            gravityX = newestAccel.acceleration.x;
            else if(orientation == UIInterfaceOrientationPortrait)
                gravityX = newestAccel.acceleration.x;
                else if(orientation == UIInterfaceOrientationLandscapeLeft)
                gravityX = newestAccel.acceleration.y;
                    else if(orientation == UIInterfaceOrientationLandscapeRight)
                    gravityX = -newestAccel.acceleration.y;
                       else gravityX = -newestAccel.acceleration.x;
        
        return gravityX;
        
    } else
       return 0;
}

- (CGPoint)calculateForseForElementAtIndexX: (int) x Y: (int) y {  // Function Calculates overal force
	CGPoint forse;
	forse.x=  GravityX;
	forse.y=  GravityY;      // Ading gravity force
    if ((x+1) < XDots)       // Not right row
       forse = [self addForses:forse and:[self elementaryForseBetwen:self.drawView->g_DotNet[x][y]  and:self.drawView->g_DotNet[x+1][y]]];
    if ((x-1) >= 0)          // Not left row
       forse = [self addForses:forse and:[self elementaryForseBetwen:self.drawView->g_DotNet[x][y]  and:self.drawView->g_DotNet[x-1][y]]];
    if ((y+1) < YDots)       // Not at bottom
       forse = [self addForses:forse and:[self elementaryForseBetwen:self.drawView->g_DotNet[x][y]  and:self.drawView->g_DotNet[x][y+1]]];
    if ((y-1) >= 0)          // Not first column
       forse = [self addForses:forse and:[self elementaryForseBetwen:self.drawView->g_DotNet[x][y]  and:self.drawView->g_DotNet[x][y-1]]];
	return forse;
}

- (void)deformation{  // Moving dots with "Forse" dT(iterations) times
    GravityX = [self gravityX]*DotMass;
    GravityY = -[self gravityY]*DotMass;
	CGPoint total_forse=CGPointZero;
	int i,k,j;
	for (j=0;j<=iterations;j++){    // Iterations
       for(k=0;k<YDots;k++)
		   for(i=0;i<XDots;i++){
               BOOL breakFor = false;
                for (DragDot *Dragdot in self.DragDotsArray) {
                       if (Dragdot.x == i && Dragdot.y == k)
                           breakFor=true;
                }
                for (DragDot *Dragdot in self.StaticDotsArray) {
                   if (Dragdot.x == i && Dragdot.y == k)
                       breakFor=true;
                }
                if (breakFor)
                    continue;
                CGPoint forse= [self calculateForseForElementAtIndexX:i Y:k];
               
                self->isVisible = false;
                if  ((self.drawView->g_DotNet[i][k].x > 0) &&  (self.drawView->g_DotNet[i][k].x < [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation].width+500)  && self.drawView->g_DotNet[i][k].y < [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation].height+500 && self.drawView->g_DotNet[i][k].y>0)
                   self->isVisible = true;
                self.drawView->g_DotNet[i][k] = [self addForses: self.drawView->g_DotNet[i][k]  and: forse];
                total_forse = [self addForses:total_forse  and:[self calculateForseForElementAtIndexX:i Y:k]];
			}
	}
    [self.view setNeedsDisplay];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DragDot *dragdot = [DragDot new];
    dragdot.x=0;
    dragdot.y=0;
    [self.StaticDotsArray addObject:dragdot];
    dragdot = nil;
    dragdot = [DragDot new];
    dragdot.x=0;
    dragdot.y=YDots-1;       //YDots-1;
    [self.StaticDotsArray addObject:dragdot];
    [self initDotNetToOrientation:[UIApplication sharedApplication].statusBarOrientation];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0/timerFrequency target:self selector:@selector(deformation) userInfo:nil repeats:YES];
    self->isVisible = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_motionManager stopAccelerometerUpdates];
    _motionManager = nil;
}

@end
