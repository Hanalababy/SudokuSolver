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
    
    /*add 9*9 cells*/
    float l=(self.view.frame.size.width-8)/11;
    cellArray=[[NSMutableArray alloc] init];
    for(int i=0;i!=9;i++)
        for(int j=0;j!=9;j++)
        {
            UITextView* cell=[[UITextView alloc] initWithFrame:CGRectMake(l+(l+1)*j, 100+(l+1)*i, l, l)];
            UIColor *color=[[colorArray objectAtIndex:(i/3)] objectAtIndex:(j/3)];
            cell.layer.borderColor=color.CGColor;
            cell.layer.borderWidth=2.0f;
            cell.textColor=color;
            cell.keyboardType=UIKeyboardTypeNumberPad;
            cell.font=[UIFont systemFontOfSize:18.0];
            cell.textAlignment=UITextAlignmentCenter;
            cell.delegate=self;
           // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:)name:@"UITextViewTextDidChangeNotification" object:cell];

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
    //[animation addTarget:self action:@selector(try) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: animation];
    
    
    /*reset button*/
    UIButton* reset=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3/4-40,50,80,40)];
    [reset setTitle:@"RESET" forState:UIControlStateNormal];
    reset.backgroundColor = [UIColor blackColor];
    [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: reset];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    NSString *s = textView.text;
    if(s.length>0)
        textView.text = [s substringFromIndex:s.length-1];
}

-(void) reset{
    for(int i=0;i!=9;i++)
    {
        for(int j=0;j!=9;j++)
        {
            UITextView* cell=[cellArray objectAtIndex:i*9+j];
            cell.text=@"";
            cell.font=[UIFont systemFontOfSize:18.0];
            cell.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
            [cellArray replaceObjectAtIndex:i*9+j withObject:cell];
            fix[i][j]=0;
        }
    }
}

-(void) submit{
    animate=0;
    /**********MARK************/
    NSThread * myThread = [[NSThread alloc]initWithTarget:self selector:@selector(start) object:nil];
    [myThread start];
    
    
}

-(void) animation{
    animate=1;
    /**********MARK************/
    NSThread * myThread = [[NSThread alloc]initWithTarget:self selector:@selector(start) object:nil];
    [myThread start];
    
    
}


-(void) start{
    for(int i=0;i!=[cellArray count];i++)
    {
        UITextView* cell=[cellArray objectAtIndex:i];
        fix[i/9][i%9]=cell.text.intValue;
        Row[i/9][i%9]=cell.text.intValue;
    }
    
    /*verify the entries*/
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            if(fix[i][j]!=0)
            {
                if(![self checkNum:fix[i][j] Row:i Column:j]){
                    
                    NSLog(@"Wrong entry");
                    return;
                }
            }
        }
    
    do{}while([self putFix]);
    [self putFix];
    [self putNum];
}


-(BOOL)putFix{
    int find=0;
    int count=0;
    int num=0;
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            if(fix[i][j]!=0)
                continue;
            else{
                num=0;
                count=0;
                for(int n=1;n<=9;n++)
                {
                    if([self checkNum:n Row:i Column:j]){
                        count+=1;
                        num=n;
                    }
                }
                if(count==1){
                    fix[i][j]=num; //fixNum
                    Row[i][j]=num;  //current filled
                    find=1;
                }
            }
            
        }
    return find==1;
}

-(void) putNum{
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            if(fix[i][j]!=0)
                continue;
            else
            {
                for(int n=1;n<=10;n++)
                {
                    if(n<=9)
                    {
                         if([self checkNum:n Row:i Column:j])
                        {
                            Row[i][j]=n;
                             /*******/
                            if(animate==1){
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
                        Row[i][j]=0;
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
                            if(fix[ti][tj]==0)
                            {
                                i=ti;
                                j=tj;
                                n=Row[i][j];
                                Row[i][j]=0;

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
        [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}


-(void) show
{
    for(int i=0;i!=9;i++)
    {
        for(int j=0;j!=9;j++)
        {
            UITextView* cell=[cellArray objectAtIndex:j*9+i ];
            if(Row[j][i]==0) cell.text=@"";
            else cell.text=[NSString stringWithFormat:@"%d",Row[j][i]];
            if(fix[j][i]==Row[j][i]) cell.font = [UIFont boldSystemFontOfSize:18.0];
            else cell.font=[UIFont systemFontOfSize:18.0];
            [cellArray replaceObjectAtIndex:j*9+i withObject:cell];
        }
    }
}

/***************************************new version*********************************************/
-(void) try{
    for(int i=0;i!=[cellArray count];i++)
    {
        UITextView* cell=[cellArray objectAtIndex:i];
        if([cell.text isEqualToString:@""]) Row[i/9][i%9]=0;
        else Row[i/9][i%9]=cell.text.intValue;
    }
    [self showAvailableNums];
}
-(void)showAvailableNums{
   
    
    for(int i=0;i!=9;i++){
        for(int j=0;j!=9;j++){
            if(Row[i][j]==0){
                NSString* result=@"";
                for(int n=1;n<=9;n++){
                    if([self checkNum:n Row:i Column:j]){
                        result=[NSString stringWithFormat:@"%@%d", result,n];
                    }
                    else{
                        result=[NSString stringWithFormat:@"%@%@", result,@" "];
                    }
                    result=[NSString stringWithFormat:@"%@%@", result,@" "];
                    if(n==3||n==6){
                        result=[NSString stringWithFormat:@"%@%@", result,@"\n"];
                    }
                }
                UITextView* cell=[cellArray objectAtIndex:i*9+j ];
                //cell.contentInset = UIEdgeInsetsMake(-5.f, 0.f, 0.f, 0.f);
                cell.font = [UIFont boldSystemFontOfSize:5.0];
                cell.text=result;
                NSLog(@"%@",result);
            }
        }
    }
}

-(bool)checkNum:(int) n Row:(int) i Column:(int) j{
    for(int k=0;k!=9;k++){
        if(k!=j&&Row[i][k]==n){
            return false;
        }
    }
    for(int k=0;k!=9;k++){
        if(k!=i&&Row[k][j]==n){
            return false;
        }
    }
    for(int a=0;a!=3;a++){
        for(int b=0;b!=3;b++){
            if(i/3*3+a!=i&&j/3*3+b!=j&&Row[i/3*3+a][j/3*3+b]==n){
                return false;
            }
        }
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
