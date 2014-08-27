//
//  IWAFilterViewController.m
//  Instawhat?
//
//  Created by Katlyn Schwaebe on 8/25/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "IWAFilterViewController.h"
#import "IWAChosenFilterViewController.h"

@interface IWAFilterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation IWAFilterViewController
{
    UIImageView * imageView;
    UICollectionView * filterCollection;
    NSArray * filters;
    NSMutableDictionary * filteredImage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        filters = @[
//                    @"CIColorCrossPolynomial",
//                    @"CIColorCube",
//                    @"CIColorCubeWithColorSpace",
                    @"CIColorInvert",
//                    @"CIColorMap",
                    @"CIColorMonochrome",
//                    @"CIColorPosterize",
//                    @"CIFalseColor",
//                    @"CIMaskToAlpha",
//                    @"CIMaximumComponent",
//                    @"CIMinimumComponent",
//                    @"CIPhotoEffectChrome",
//                    @"CIPhotoEffectFade",
//                    @"CIPhotoEffectInstant",
//                    @"CIPhotoEffectMono",
//                    @"CIPhotoEffectNoir",
//                    @"CIPhotoEffectProcess",
//                    @"CIPhotoEffectTonal",
//                    @"CIPhotoEffectTransfer",
                    @"CISepiaTone",
                    @"CIVignette",
                    @"CIVignetteEffect"
                    ];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    
        [self.view addSubview:imageView];
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        filterCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 320, 320, [UIScreen mainScreen].bounds.size.height - 320) collectionViewLayout:layout];
        filterCollection.dataSource = self;
        filterCollection.delegate = self;
        [filterCollection registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:filterCollection];
        filteredImage = [@{} mutableCopy];
    }
    return self;
}
-(void)setOriginalImage:(UIImage *)originalImage
{
    
    _originalImage = originalImage;
    
    imageView.image = originalImage;
//    originalImage = [self normalizedImage:[UIImagePickerControllerOriginalImage]];
//    [self showFilterWithImage: originalImage];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filters.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString * filterName = filters[indexPath.item];
    UIImageView * filterView = [[UIImageView alloc] initWithFrame:cell.bounds];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage * filterImage = [self filterImageWithFilterName:filterName];
        dispatch_async(dispatch_get_main_queue(), ^{
            filterView.image = filterImage;
            [filteredImage setObject:filterImage forKey:[NSString stringWithFormat:@"%d", indexPath.item]];
        });
        
    });
    
//    filterView.image = [self filterImageWithFilterName:filterName];
    [cell addSubview:filterView];
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) filterImageWithFilterName:(NSString *)filterName
{
    // turn uiimage into ciimage
    CIImage * ciImage = [CIImage imageWithCGImage:self.originalImage.CGImage];
    // create cifilter with filtername
    CIFilter * filter = [CIFilter filterWithName:filterName];
    //add ciimage to the filter
    [filter setValue:ciImage forKeyPath:kCIInputImageKey];
    //get filtered image from filter
    CIImage * ciResult = [filter outputImage];
    // setup context to turn ciimage into cgimage
    CIContext * ciContext = [CIContext contextWithOptions:nil];
    // init uiimage with cgimage
    return [UIImage imageWithCGImage:[ciContext createCGImage:ciResult fromRect:[ciResult extent]]];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage * fixedImage = [self normalizedImage:UIImagePickerControllerOriginalImage];
    [self showFilterWithImage: fixedImage];
    [self showFilterWithImage:filteredImage[[NSString stringWithFormat:@"%d", indexPath.item]]];
//}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage * fixedImage = [self normalizedImage:info[UIImagePickerControllerOriginalImage]];
//    [self showFilterWithImage: fixedImage];

    
}
- (UIImage *)normalizedImage:(UIImage*)normalImage
{
    if (normalImage.imageOrientation == UIImageOrientationUp) return normalImage;
    
    UIGraphicsBeginImageContextWithOptions(normalImage.size, NO, normalImage.scale);
    [normalImage drawInRect:(CGRect){0, 0, normalImage.size}];
    UIImage * normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
-(void)showFilterWithImage:(UIImage *)image
{
    IWAChosenFilterViewController * filteredVC1 = [[IWAChosenFilterViewController alloc]init];
    filteredVC1.filteredImage = image;
    [self.navigationController pushViewController:filteredVC1 animated:YES];
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
