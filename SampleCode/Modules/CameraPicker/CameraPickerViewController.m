//
//  KNCameraPickerTemplateViewController.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

#import "CameraPickerViewController.h"
#import "UserManager.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "ActionSheetDelegate.h"

@interface CameraPickerViewController ()<UIActionSheetDelegate>
{
    UIImagePickerController* camera;
    
}


@end

@implementation CameraPickerViewController{
    UIViewController *containVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageSent:) name:kImageSent object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.currentImagePath)
        self.preview.image=[UIImage imageWithContentsOfFile:self.currentImagePath];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.preview.image=nil;
}

#pragma mark - IB Actions

-(IBAction)launchCamera:(id)sender{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: LOCALIZATION(@"Get Picture From")
                                                       delegate:self cancelButtonTitle: LOCALIZATION(@"Cancel")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:
                            LOCALIZATION(@"Camera"),
                            LOCALIZATION(@"Photos"),
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
 
    if ([sender isKindOfClass:[UIViewController class]]) {
        
        containVC = sender;
    }else{
        containVC = self;
    }
}

#pragma mark - Generate Image name & path

- (NSString*) generateImageName{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy-HHmmss"];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@", ret ];
}

- (NSString*) generateImagePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@.jpg",[self generateImageName]]];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];//[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(image, nil,nil,nil);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self onImagePicked:image];
    
    [containVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [containVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Picked

- (void) onImagePicked:(UIImage*) image{
    
//    self.currentImagePath = [self generateImagePath];
//    [UIImageJPEGRepresentation(image, 0.5f) writeToFile:self.currentImagePath atomically:YES];
//    
//    UIImage *imageTmp = [UIImage imageWithContentsOfFile:self.currentImagePath];
//    self.preview.image= imageTmp;
    
    self.preview.image = image;
    [self.delegate didSelectedImage:image];
}

- (void) onImageSent:(NSNotification*) notification
{
    self.preview.image=nil;
    self.currentImagePath = nil;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // From Camera
            
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                camera = [[UIImagePickerController alloc] init];
                camera.allowsEditing = YES;
                
                camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                if (self.isFrontCameraUsed) {
                    camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                
                [camera setDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) self];
                camera.modalPresentationStyle = UIModalPresentationFullScreen;
                [containVC presentViewController:camera animated:YES completion:nil];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"Error") message:LOCALIZATION(@"Your device doesn't have a camera") delegate:nil cancelButtonTitle:LOCALIZATION(@"Ok") otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        case 1: // From Photos
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary])
            {
                camera = [[UIImagePickerController alloc] init];
                camera.allowsEditing = YES;
                
                camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [camera setDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) self];
                camera.modalPresentationStyle = UIModalPresentationFullScreen;

                camera.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage,nil];
                [containVC presentViewController:camera animated:YES completion:nil];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"Error") message:LOCALIZATION(@"Your device doesn't have a photo library") delegate:nil cancelButtonTitle:LOCALIZATION(@"Ok") otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}
@end
