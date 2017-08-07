#import "ShareViewController.h"
#import "ItemViewController.h"
@interface ShareViewController ()

@end
SLComposeSheetConfigurationItem *item;
ItemViewController *vc;
@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}
- (void)didSelectPost {
    
    for (NSItemProvider* itemProvider in ((NSExtensionItem*)self.extensionContext.inputItems[0]).attachments ) {
        
        if([itemProvider hasItemConformingToTypeIdentifier:@"public.jpeg"]) {
            NSLog(@"itemprovider = %@", itemProvider);
            
            [itemProvider loadItemForTypeIdentifier:@"public.jpeg" options:nil completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
                
                NSData *imgData;
                if([(NSObject*)item isKindOfClass:[NSURL class]]) {
                    imgData = [NSData dataWithContentsOfURL:(NSURL*)item];
                }
                if([(NSObject*)item isKindOfClass:[UIImage class]]) {
                    imgData = UIImagePNGRepresentation((UIImage*)item);
                }
                
                NSDictionary *dict = @{
                                       @"imgData" : imgData,
                                       @"name" : self.contentText
                                       };
                NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.containingapp"];
                [defaults setObject:dict forKey:@"img"];
                [defaults synchronize];
            }];
        }
    }
    
    
    
}
- (NSArray *)configurationItems {
    item = [[SLComposeSheetConfigurationItem alloc] init];
    // Give your configuration option a title.
    [item setTitle:@"Item One"];
    // Give it an initial value.
    [item setValue:@"None"];
    // Handle what happens when a user taps your option.
    [item setTapHandler:^(void){
        vc = [[ItemViewController alloc] init];
        // Transfer to your configuration view controller.
        [self pushConfigurationViewController:vc];
        
    }];
    // Return an array containing your item.
    return @[item];
    
}
-(void) sendingViewController:(ItemViewController *)controller sentItem:(NSString *)retItem {
    // Set the configuration item's value to the returned value
    [item setValue:retItem];
    // Pop the configuration view controller to return to this one.
    [self popConfigurationViewController];
}


@end
