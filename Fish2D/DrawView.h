//
//  DrawView.h
//  Fish2D
//
//  Created by Igor Kovrizhkin on 5/28/13.
//  Copyright (c) 2013 kovrizhkin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YDots 10    
#define XDots 10


@interface DrawView : UIView {
    @public CGPoint g_DotNet[XDots][YDots];
    @protected CGContextRef curCGcontext;
    @public int spread;
}

@end
