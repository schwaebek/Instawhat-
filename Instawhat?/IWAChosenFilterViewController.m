//
//  IWAChosenFilterViewController.m
//  Instawhat?
//
//  Created by Katlyn Schwaebe on 8/26/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "IWAChosenFilterViewController.h"
#import <Parse/Parse.h> 


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface IWAChosenFilterViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@end

@implementation IWAChosenFilterViewController
{
    UIView * captionHolder;
    UIImageView * imageView;
    UITextView * captionView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20 , SCREEN_HEIGHT/2)];
        imageView.backgroundColor = [UIColor purpleColor];
    }
    return self;
}
- (void)viewDidLoad {

     [super viewDidLoad];

    
   // self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView * masterView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    masterView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:masterView];
    
    
    [self.view addSubview:imageView];
    
//    UIView * minorView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2, SCREEN_WIDTH -20, 300)];
//    minorView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:minorView];
//    
    
    captionHolder = [[UIView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT/2) + 10, SCREEN_WIDTH -40, 200)];
    captionHolder.backgroundColor = [UIColor lightGrayColor];
    captionHolder.layer.borderWidth = 10;
    captionHolder.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:captionHolder];
    
    captionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, captionHolder.frame.size.width, captionHolder.frame.size.height )];
    
    captionView.delegate = self;
    
    [captionHolder addSubview:captionView];
    
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0,captionHolder.frame.size.height-70, 320, 70)];
    submitButton.backgroundColor = [UIColor orangeColor];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitPost) forControlEvents:UIControlEventTouchUpInside];
    
    [captionHolder addSubview:submitButton];
   
    // Do any additional setup after loading the view.


    // Dispose of any resources that can be recreated.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) submitPost
{
    PFObject * face = [PFObject objectWithClassName:@"Faces"];
    [face setObject:captionView.text forKey:@"text"];
    NSData * data = UIImagePNGRepresentation(imageView.image);
    PFFile * file = [PFFile fileWithData:data];
    [face setObject:file forKey:@"image"];
    [face saveInBackground];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 animations:^{
        captionHolder.center = CGPointMake(captionHolder.center.x, captionHolder.center.y -216);
    }];
    
}
-(void)setFilteredImage:(UIImage *)filteredImage
{
    _filteredImage = filteredImage;
    imageView.image = filteredImage;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
