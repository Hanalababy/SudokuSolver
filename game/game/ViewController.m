//
//  ViewController.m
//  game
//
//  Created by Tang Hana on 2017/1/18.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*set colors*/
    NSMutableArray * colorArray=[[NSMutableArray alloc] init];
    NSMutableArray * color1Array=[[NSMutableArray alloc] init];
    NSMutableArray * color2Array=[[NSMutableArray alloc] init];
    NSMutableArray * color3Array=[[NSMutableArray alloc] init];
    [color1Array addObject:[UIColor blueColor]];
    [color1Array addObject:[UIColor purpleColor]];
    [color1Array addObject:[UIColor blackColor]];
    [color2Array addObject:[UIColor purpleColor]];
    [color2Array addObject:[UIColor blackColor]];
    [color2Array addObject:[UIColor blueColor]];
    [color3Array addObject:[UIColor blackColor]];
    [color3Array addObject:[UIColor blueColor]];
    [color3Array addObject:[UIColor purpleColor]];
    [colorArray addObject:color1Array];
    [colorArray addObject:color2Array];
    [colorArray addObject:color3Array];
    
    /*add 9*9*/
    float l=(self.view.frame.size.width-8)/13;
    cellArray=[[NSMutableArray alloc] init];
    for(int i=0;i!=9;i++)
        for(int j=0;j!=9;j++)
        {
            UITextField* cell=[[UITextField alloc] initWithFrame:CGRectMake(2*l+(l+1)*i, 150+(l+1)*j, l, l)];
            UIColor *color=[[colorArray objectAtIndex:(i/3)] objectAtIndex:(j/3)];
            cell.layer.borderColor=color.CGColor;
            cell.layer.borderWidth= 2.0f;
            cell.textColor=color;
            cell.keyboardType=UIKeyboardTypeNumberPad;
            cell.textAlignment=UITextAlignmentCenter;
            cell.delegate=self;
            [cell addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cellArray addObject:cell];
            [self.view addSubview:cell];
        }
    
    /*submit button*/
    UIButton* submit=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-40,50,80,40)];
    [submit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor blackColor];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: submit];
    
    /*animate button*/
    UIButton* animation=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2/4-40,50,80,40)];
    [animation setTitle:@"ANIMATE" forState:UIControlStateNormal];
    animation.backgroundColor = [UIColor blackColor];
    [animation addTarget:self action:@selector(animation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: animation];
    
    
    /*reset button*/
    UIButton* reset=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3/4-40,50,80,40)];
    [reset setTitle:@"RESET" forState:UIControlStateNormal];
    reset.backgroundColor = [UIColor blackColor];
    [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: reset];
    
}

-(void)textFieldDidChange:(UITextField *)textField{
    NSString *s = textField.text;
    if(s.length>0)
        textField.text = [s substringFromIndex:s.length-1];
}

-(void) reset{
    for(int i=0;i!=9;i++)
    {
        for(int j=0;j!=9;j++)
        {
            UITextField* cell=[cellArray objectAtIndex:j*9+i];
            cell.text=@"";
            [cellArray replaceObjectAtIndex:j*9+i withObject:cell];
            fix[i][j]=0;
        }
    }
}

-(void) submit{
    animate=0;
    //[self putNum:row andColumn:column andBlock:block andFix:fix];
    
    /**********MARK************/
    NSThread * myThread = [[NSThread alloc]initWithTarget:self selector:@selector(start) object:nil];
    [myThread start];
    
    
}

-(void) animation{
    animate=1;
    //[self putNum:row andColumn:column andBlock:block andFix:fix];
    
    /**********MARK************/
    NSThread * myThread = [[NSThread alloc]initWithTarget:self selector:@selector(start) object:nil];
    [myThread start];
    
    
}


-(void) start{
    for(int i=0;i!=[cellArray count];i++)
    {
        UITextField* cell=[cellArray objectAtIndex:i];
        fix[i/9][i%9]=cell.text.intValue;
    }
    
    int row [9][9];
    int column [9][9];
    int block [9][9];
    
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            row[i][j]=fix[i][j];
            column[j][i]=fix[i][j];
            block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=fix[i][j];
        }
    
    /*verify the entries*/
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            if(fix[i][j]!=0)
            {
                row[i][j]=0;
                column[j][i]=0;
                block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=0;
                if(![self checkNum:fix[i][j] andI:i andJ:j andRow:row andColumn:column andBlock:block]){
                    
                    NSLog(@"Wrong entry");
                    return;
                }
                row[i][j]=fix[i][j];
                column[j][i]=fix[i][j];
                block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=fix[i][j];
            }
        }
    
    do{}while([self putFix:row andColumn: column andBlock:block andFix:fix]);[self putFix:row andColumn: column andBlock:block andFix:fix];
    [self putNum:row andColumn:column andBlock:block andFix:fix];
}


//i j -> cubeI cubeJ
-(int)blockI:(int) i andJ:(int) j
{
    return ((i / 3)*3) + (j / 3);
}
-(int)blockJ:(int) i andJ:(int) j
{
    return ((i % 3)*3) + (j % 3);
}
//chech if the number could be filled in
-(BOOL)checkNum:(int) n andI:(int) i andJ:(int) j andRow:(int[9][9]) row andColumn:(int[9][9]) column andBlock:(int[9][9]) block
{
    int result=0;
    for(int k=0;k<9;k++)
    {
        if(n==row[i][k])
            result=1;
    }
    for(int k=0;k<9;k++)
    {
        if(n==column[j][k])
            result=1;
    }
    for(int k=0;k<9;k++)
    {
        if(n==block[[self blockI:i andJ:j]][k])
            result=1;
    }
    
    if(result==1)
        return FALSE;
    else
        return TRUE;
}
//check if fixed number
-(BOOL)checkFix:(int) i andJ:(int) j andFix:(int[9][9]) fixN
{
    return (fixN[i][j]!=0);
}

//find final fixed
-(BOOL)checkRow:(int) n andI:(int) i andJ:(int) j andRow:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    for(int k=0;k<9;k++)
    {
        if([self checkFix:i andJ:k andFix:fixN]||k==j)
            continue;
        else if([self checkNum:n andI:i andJ:k andRow:row andColumn:column andBlock:block])
            return FALSE;
    }
    return TRUE;
}
-(BOOL)checkColumn:(int) n andI:(int) i andJ:(int) j andRow:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    for(int k=0;k<9;k++)
    {
        if([self checkFix:k andJ:j andFix:fixN]||k==i)
            continue;
        else if([self checkNum:n andI:k andJ:j andRow:row andColumn:column andBlock:block])
            return FALSE;
        
    }
    return TRUE;
}
-(BOOL)checkBlock:(int) n andI:(int) i andJ:(int) j andRow:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    for(int k=0;k<9;k++)
    {
        if([self checkFix:([self blockI:i andJ:j]/3)*3+k/3 andJ:([self blockI:i andJ:j]%3)*3+k%3 andFix:fixN]||(([self blockI:i andJ:j]/3)*3+k/3==i && ([self blockI:i andJ:j]%3)*3+k%3 ==j))
            continue;
        else if([self checkNum:n andI:([self blockI:i andJ:j]/3)*3+k/3 andJ:([self blockI:i andJ:j]%3)*3+k%3 andRow:row andColumn:column andBlock:block])
            return FALSE;
    }
    return TRUE;
}


-(BOOL)putFix:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    int find=0;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            if([self checkFix:i andJ:j andFix:fixN])
                continue;
            else
                for(int n=1;n<=9;n++)
                {
                    
                    if([self checkNum:n andI:i andJ:j andRow:row andColumn:column andBlock:block]&&([self checkRow:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]||[self checkColumn:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]||[self checkBlock:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]))
                    {
                        row[i][j]=n;
                        column[j][i]=n;
                        block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=n;
                        fixN[i][j]=n;
                        find=1;
                        break;
                    }
                    
                }
        }
    if (find==0)
        return FALSE;
    else
        return TRUE;
}


-(void)putFixShow:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            if([self checkFix:i andJ:j andFix:fixN])
                continue;
            else
                for(int n=1;n<=9;n++)
                {
                    
                    if([self checkNum:n andI:i andJ:j andRow:row andColumn:column andBlock:block]&&([self checkRow:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]||[self checkColumn:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]||[self checkBlock:n andI:i andJ:j andRow:row andColumn:column andBlock:block andFix:fixN]))
                    {
                        row[i][j]=n;
                        column[j][i]=n;
                        block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=n;
                        fixN[i][j]=n;
                        break;
                    }
                    
                }
        }
}


-(void) putNum:(int[9][9])row andColumn:(int[9][9])column andBlock:(int[9][9])block andFix:(int[9][9])fixN
{
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            if([self checkFix:i andJ:j andFix:fixN])
                continue;
            else
            {
                for(int n=1;n<=10;n++)
                {
                    if(n<=9)
                    {
                        if([self checkNum:n andI:i andJ:j andRow:row andColumn:column andBlock:block])
                        {
                            row[i][j]=n;
                            column[j][i]=n;
                            block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=n;
                            
                            /*******/
                            if(animate==1)
                            {
                                for(int a=0;a!=9;a++)
                                    for(int b=0;b!=9;b++)
                                        Row[a][b]=row[a][b];
                                [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                [NSThread sleepForTimeInterval:0.1];
                            }
                            /*******/
                            break;
                            
                        }
                        else
                            continue;
                    }
                    else
                    {
                        row[i][j]=0;
                        column[j][i]=0;
                        block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=0;
                        int ti=0,tj=0;
                        if(j==0)
                        {
                            ti=(i-1);
                            tj=8;
                        }
                        else
                        {
                            ti=i;
                            tj=(j-1);
                        }
                        
                        do
                        {
                            if(ti<0)
                            {
                                NSLog(@"No Solution"); //no solution
                                return;
                            }
                            if(fixN[ti][tj]==0)
                            {
                                i=ti;
                                j=tj;
                                n=row[i][j];
                                row[i][j]=0;
                                column[j][i]=0;
                                block[[self blockI:i andJ:j]][[self blockJ:i andJ:j]]=0;
                                break;
                            }
                            if(tj==0)
                            {
                                tj=8;
                                ti--;
                            }
                            else
                                tj--;
                        }while(1);
                    }
                }
                
            }
        }
    }
    
    /*****************/
    if(animate==0)
    {
        for(int a=0;a!=9;a++)
            for(int b=0;b!=9;b++)
                Row[a][b]=row[a][b];
        [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}


-(void) show
{
    for(int i=0;i!=9;i++)
    {
        for(int j=0;j!=9;j++)
        {
            UITextField* cell=[cellArray objectAtIndex:j*9+i ];
            if(Row[j][i]==0) cell.text=@"";
            else cell.text=[NSString stringWithFormat:@"%d",Row[j][i]];
            if(fix[j][i]==Row[j][i]) cell.font = [UIFont boldSystemFontOfSize:18.0];
            else cell.font=[UIFont systemFontOfSize:18.0];
            [cellArray replaceObjectAtIndex:j*9+i withObject:cell];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
