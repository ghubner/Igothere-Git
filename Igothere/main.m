    //
//  main.m
//  Igothere
//
//  Created by Gilberto on 9/9/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        int retVal;
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *e) {
            NSLog(@"CRASH: %@", e);
            NSLog(@"Stack Trace: %@", [e callStackSymbols]);
            
        }
        @finally {
            
        }
        return retVal;
    }
}

