//
//  UploadImageControl.m
//  HN_ERP
//
//  Created by tomwey on 25/10/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "UploadImageControl.h"
#import "Defines.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "UIButton+AFNetworking.h"

//#import <PhotosUI/PhotosUI.h>

@interface UploadImageControl () <TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *imageButtons;

@property (nonatomic, strong) AFHTTPRequestOperation *uploadOperation;

@property (nonatomic, strong) NSArray *uploadImages;

@property (nonatomic, strong) NSArray *currentUploadedIDs;

@property (nonatomic, strong) NSMutableArray *totalUploadImages;

@end

@interface ImagePreviewVC : BaseNavBarVC

@end

#define kButtonCountPerRow 4

@implementation UploadImageControl

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if ( self = [super initWithFrame:frame] ) {
//        [self.imageButtons addObject:self.addButton];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(deleteImage:)
//                                                     name:@"kUploadedImageDidDeleteNotification"
//                                                   object:nil];
//    }
//    return self;
//}

- (instancetype)initWithAttachments:(NSArray *)attachments
{
    if (self = [super init]) {
        [self.imageButtons addObject:self.addButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deleteImage:)
                                                     name:@"kUploadedImageDidDeleteNotification"
                                                   object:nil];
        
        self.uploadImages = attachments;
        
        [self addImages];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = ( self.width - (kButtonCountPerRow - 1) * 5 ) / kButtonCountPerRow;
    
//    NSInteger row = (self.imageButtons.count + kButtonCountPerRow - 1) / kButtonCountPerRow;
//    self.height = row * ( width + 5 ) - 5;
//    
    for (int i=0; i<self.imageButtons.count; i++) {
        UIButton *btn = self.imageButtons[i];
        
        btn.frame = CGRectMake(0, 0, width, width);
        
        int dtx = i % kButtonCountPerRow;
        int dty = i / kButtonCountPerRow;
        
        btn.position = CGPointMake(( width + 5 ) * dtx,
                                   ( width + 5) * dty);
    }
}

- (UIButton *)addButton
{
    if ( !_addButton ) {
        _addButton = AWCreateTextButton(CGRectZero,
                                        @"+",
                                        AWColorFromRGB(74, 74, 74),
                                        self,
                                        @selector(addImage));
        [self addSubview:_addButton];
        
        _addButton.layer.borderColor = _addButton.currentTitleColor.CGColor;
        _addButton.layer.borderWidth = 0.6;
        
        _addButton.titleLabel.font = AWSystemFontWithSize(18, NO);
    }
    return _addButton;
}

- (void)addImage
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self];
    
    imagePickerVC.allowTakePicture  = YES;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingOriginalPhoto = YES;
    
    imagePickerVC.didFinishPickingPhotosHandle = ^( NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto ) {
        NSLog(@"photos: %@, assets: %@, origin: %d", photos, assets, isSelectOriginalPhoto);
        //        [self uploadImages:photos mimeType:@"image/png"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (id asset in assets) {
            if ( [asset isKindOfClass:[PHAsset class]] ) {
                [[self class] getImageFromPHAsset:asset completion:^(NSData *data, NSString *filename, NSURL *imageURL) {
                    if ( data && filename ) {
                        [tempArray addObject:@{ @"imageData": data,
                                                @"imageName": filename,
//                                                @"imageURL": imageURL ?: @"",
                                                }];
                    }
                }];
            }
        }
        
        self.uploadImages = tempArray;
        
        [self uploadImages:tempArray mimeType:@"image/png"];
    };
    
    //        imagePickerVC.didFinishPickingVideoHandle = ^(UIImage *coverImage,id asset) {
    //            NSLog(@"coverImage: %@, asset: %@", coverImage, asset);
    //            if ( [asset isKindOfClass:[PHAsset class]] ) {
    //                PHAsset *movAsset = (PHAsset *)asset;
    //                [[self class] getVideoFromPHAsset:movAsset completion:^(NSData *data, NSString *filename) {
    //                    [self uploadData:data fileName:filename mimeType:@"video/mp4"];
    //                }];
    //            }
    //            //        [self uploadData: fileName:@"file.mov" mimeType:@"video/mp4"];
    //        };
    
    [self.owner presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)cancelUpload
{
    [self.uploadOperation cancel];
    self.uploadOperation = nil;
}

- (void)uploadFile:(NSDictionary *)params
     formDataBlock:( void (^)(id<AFMultipartFormData>  _Nonnull formData) )formDataBlock
{
    if (!self.annexTableName || !self.annexFieldName) {
        return;
    }
    
    [self cancelUpload];
    
    id user = [[UserService sharedInstance] currentUser];
    NSString *manID = [user[@"man_id"] description];
    manID = manID ?: @"0";
    
    [[MBProgressHUD appearance] setContentColor:MAIN_THEME_COLOR];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:AWAppWindow() animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.progress = 0.0f;
    hud.label.text = @"上传中...";
    
    NSString *tableName = self.annexTableName;//@"H_APP_Supplier_Contract_Change_Annex";
    NSString *fieldname = self.annexFieldName;//@"AnnexKeyID";
    NSString *mid = @"0";//self.params[@"mid"] ?: @"0";
//    if (self.currentAttachmentFormControl) {
//        //        id val = self.formObjects[self.currentAttachmentFieldName];
//        NSArray *temp = [self.currentAttachmentFormControl[@"item_value"] componentsSeparatedByString:@","];
//        if ( [temp firstObject] ) {
//            tableName = [temp firstObject];
//        }
//        
//        if ([temp lastObject]) {
//            fieldname = [temp lastObject];
//        }
//        
//        mid = @"";
//    }
    
    __weak typeof(self) weakSelf = self;
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/upload", API_HOST];
    self.uploadOperation =
    [[AFHTTPRequestOperationManager manager] POST:uploadUrl
                                       parameters:@{
                                                    @"mid": mid,
                                                    @"domanid": manID,
                                                    @"tablename": tableName,
                                                    @"fieldname": fieldname,
                                                    }
                        constructingBodyWithBlock:formDataBlock
                                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         [weakSelf handleAnnexUploadSuccess:responseObject];
     }
     
                                          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
     {
         //
         NSLog(@"error: %@",error);
         [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
         [AWAppWindow() showHUDWithText:@"附件上传失败" succeed:NO];
     }];
    [self.uploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%f", totalBytesWritten / (float)totalBytesExpectedToWrite);
        hud.progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
    }];
    
}

- (void)handleAnnexUploadSuccess:(id)responseObject
{
    [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
    [AWAppWindow() showHUDWithText:@"附件上传成功" succeed:YES];
    
    NSArray *IDs = [responseObject[@"IDS"] componentsSeparatedByString:@","];
    self.currentUploadedIDs = IDs;
//
//    if ( IDs ) {
//        [self.attachmentIDs addObjectsFromArray:IDs];
//    }
//    
//    if ( self.currentAttachmentFieldName && IDs ) {
//        NSArray *ids = self.formObjects[self.currentAttachmentFieldName] ?: @[];
//        NSMutableArray *temp = [ids mutableCopy];
//        [temp addObjectsFromArray:IDs];
//        
//        self.formObjects[self.currentAttachmentFieldName] = temp;
//        
//        [self.tableView reloadData];
//    }
    
    [self addImages];
    
    NSLog(@"response: %@", responseObject);
}

- (void)addImages
{
    if (self.uploadImages.count == 0) return;
    
    CGFloat width = ( self.width - (kButtonCountPerRow - 1) * 5 ) / kButtonCountPerRow;
    
    int i=0;
    for (id data in self.uploadImages) {
        
        NSString *id_ = @"";
        if (i < self.currentUploadedIDs.count) {
            id_ = [self.currentUploadedIDs[i] description];
        }

        NSMutableDictionary *item = [data mutableCopy];
        [item setObject:id_ forKey:@"id"];
        
        UIButton *btn = AWCreateImageButton(nil, self, @selector(openImage:));
        [self addSubview:btn];
        [self.imageButtons insertObject:btn atIndex:0];
        
        btn.userData = item;
        
        if ( data[@"imageURL"] ) {
            [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:data[@"imageURL"]]];
        } else {
            [btn setBackgroundImage:[UIImage imageWithData:data[@"imageData"]] forState:UIControlStateNormal];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                UIImage *image = [UIImage imageWithData:data[@"imageData"]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [btn setBackgroundImage:image forState:UIControlStateNormal];
//                });
//            });
//            [btn setBackgroundImageForState:UIControlStateNormal withData:data[@"imageData"]];
        }
//        [btn setBackgroundImageForState:UIControlStateNormal withURL:data[@"imageURL"]];
        
//        if ( data[@"imageData"] ) {
//            [btn setBackgroundImage:[UIImage imageWithData:data[@"imageData"]] forState:UIControlStateNormal];
//        } else {
//            NSString *imageURL = [data[@"imageURL"] description];
//            if ( [imageURL hasPrefix:@"file:"] ) {
//                [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL fileURLWithPath:imageURL]];
//            } else {
//                [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageURL]];
//            }
//        }
        
        i++;
    }
    
    [self setNeedsLayout];
    
    NSInteger row = (self.imageButtons.count + kButtonCountPerRow - 1) / kButtonCountPerRow;
    self.height = row * ( width + 5 ) - 5;
    
    if ( self.didUploadedImagesBlock ) {
        self.didUploadedImagesBlock(self);
    }
}

- (void)updateHeight
{
    CGFloat width = ( self.width - (kButtonCountPerRow - 1) * 5 ) / kButtonCountPerRow;
    NSInteger row = (self.imageButtons.count + kButtonCountPerRow - 1) / kButtonCountPerRow;
    self.height = row * ( width + 5 ) - 5;
}

- (void)deleteImage:(NSNotification *)noti
{
    UIButton *sender = noti.object;
    
    [self close:sender];
}

- (void)close:(UIButton *)sender
{
    [self.imageButtons removeObject:sender];
    
    [sender removeFromSuperview];
    
    [self setNeedsLayout];
    
    CGFloat width = ( self.width - (kButtonCountPerRow - 1) * 5 ) / kButtonCountPerRow;
    
    NSInteger row = (self.imageButtons.count + kButtonCountPerRow - 1) / kButtonCountPerRow;
    self.height = row * ( width + 5 ) - 5;
    
    if ( self.didUploadedImagesBlock ) {
        self.didUploadedImagesBlock(self);
    }
}

- (void)openImage:(UIButton *)sender
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"ImagePreviewVC"
                                                                params:@{
                                                                         @"imageButton": sender
                                                                         }];
    [self.owner presentViewController:vc animated:YES completion:nil];
}

- (void)uploadImages:(NSArray *)images mimeType:(NSString *)mimeType
{
    [self uploadFile:@{}
       formDataBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           for (id image in images) {
               [formData appendPartWithFileData:image[@"imageData"]
                                           name:@"file"
                                       fileName:image[@"imageName"]
                                       mimeType:mimeType];
               
           }
       }];
}

+ (void)getImageFromPHAsset:(PHAsset *)asset completion:(void (^)(NSData *data,
                                                                NSString *filename,
                                                                  NSURL *imageURL) ) result {
    __block NSData *data;
    __block NSURL *imageURL;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
             imageURL = info[@"PHImageFileURLKey"];
//             NSLog(@"%@, %@", info[@"PHImageFileURLKey"], [info[@"PHImageFileURLKey"] class]);
//             NSLog(@"data uri: %@, info: %@", dataUTI, info);
             // info
//             PHImageFileDataKey = <PLXPCShMemData: 0x189d3220> bufferLength=188416 dataLength=185665;
//             PHImageFileOrientationKey = 0;
//             PHImageFileSandboxExtensionTokenKey = "d98ef2d84a8655072f9c5be9b4cd1718fe2c60b7;00000000;00000000;0000001a;com.apple.app-sandbox.read;00000001;01000003;00000000007fe4f7;/private/var/mobile/Media/DCIM/100APPLE/IMG_0295.PNG";
//             PHImageFileURLKey = "file:///var/mobile/Media/DCIM/100APPLE/IMG_0295.PNG";
//             PHImageFileUTIKey = "public.png";
//             PHImageResultDeliveredImageFormatKey = 9999;
//             PHImageResultIsDegradedKey = 0;
//             PHImageResultIsInCloudKey = 0;
//             PHImageResultIsPlaceholderKey = 0;
//             PHImageResultOptimizedForSharing = 0;
//             PHImageResultWantedImageFormatKey = 9999;
         }];
    }
    
    if (result) {
        if (data.length <= 0) {
            result(nil, nil, nil);
        } else {
            result(data, resource.originalFilename, imageURL);
        }
    }
}

- (NSMutableArray *)imageButtons
{
    if ( !_imageButtons ) {
        _imageButtons = [@[] mutableCopy];
    }
    return _imageButtons;
}

- (NSArray *)attachmentIDs
{
    NSMutableArray *IDs = [NSMutableArray array];
    for (int i=0; i<self.imageButtons.count - 1;i++) {
        UIButton *sender = self.imageButtons[i];
        [IDs addObject:sender.userData[@"id"] ?: @""];
    }
    return [IDs copy];
}

- (NSArray *)attachments
{
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<self.imageButtons.count - 1;i++) {
        UIButton *sender = self.imageButtons[i];
        [temp addObject:sender.userData ?: @{}];
    }
    return [temp copy];
}

@end

@interface ImagePreviewVC () <UIAlertViewDelegate>

@end

@implementation ImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id data  = [self.params[@"imageButton"] userData];
    self.navBar.title = data[@"imageName"];
    
    UIButton *closeBtn = HNCloseButton(34, self, @selector(close));
    [self addLeftItemWithView:closeBtn leftMargin:2];
    
    __weak typeof(self) me = self;
    [self addRightItemWithTitle:@"删除"
                titleAttributes:@{  }
                           size:CGSizeMake(44, 40)
                    rightMargin:5
                       callback:^{
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要删除吗？" message:@""
                                                                          delegate:me
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"取消", @"确定", nil];
                           [alert show];
                       }];
    
    UIImageView *imageView = AWCreateImageView(nil);
    [self.contentView addSubview:imageView];
    imageView.frame = self.contentView.bounds;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (data[@"imageURL"]) {
        [imageView setImageWithURL:[NSURL URLWithString:data[@"imageURL"]]];
    } else {
        imageView.image = [UIImage imageWithData:data[@"imageData"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self close];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUploadedImageDidDeleteNotification"
                                                            object:self.params[@"imageButton"]];
    }
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
