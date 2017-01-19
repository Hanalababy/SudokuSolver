//
//  ViewController.h
//  game
//
//  Created by Tang Hana on 2017/1/18.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    NSMutableArray *cellArray;
    NSMutableArray *entryArray;
    
    int fix[9][9];
    int rowN [9][9];
    int columnN [9][9];
    int blockN [9][9];
    int Row [9][9];
    
    bool animate;
    
    UILabel *label;
    
    
    
}


@end



