#import <Preferences/PSListController.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import <spawn.h>

@interface PFCPreferencesController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation PFCPreferencesController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)selectBackgroundImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/PasscodeBg.jpg"];
            [imageData writeToFile:path atomically:YES];
            
            HBPreferences *prefs = [HBPreferences preferencesForIdentifier:@"com.f1lony.passcodecustomizer"];
            [prefs setObject:path forKey:@"bgPath"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Готово!" message:@"Фото сохранено. Сделайте Respring для применения." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)respringDevice {
    pid_t pid;
    const char *args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
}

@end
