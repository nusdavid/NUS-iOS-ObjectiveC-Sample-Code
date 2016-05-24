//
//  KNCameraPickerTemplateViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
//  Interface of template view controller which has camera picker feature and image view for preview.

#import "BaseViewController.h"

@protocol CameraPickerViewControllerDelegate<NSObject>

@optional
-(void)didSelectedImage:(UIImage *)image;
@end


@interface CameraPickerViewController:BaseViewController <UIImagePickerControllerDelegate>

// preview image view
@property(nonatomic,weak)IBOutlet UIImageView* preview;

// method to get image file name to save it.
- (NSString*) generateImageName;

// callback when taken image
- (void) onImagePicked:(UIImage*) image;

// path of current image.
@property(nonatomic,strong) NSString* currentImagePath;

// Set type of camera will be used, default rear camare
@property(nonatomic) BOOL isFrontCameraUsed;

-(IBAction)launchCamera:(id)sender;

@property(nonatomic)id<NSObject, CameraPickerViewControllerDelegate>delegate;
@end
