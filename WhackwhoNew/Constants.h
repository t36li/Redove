//
//  Constants.h
//  WhackwhoNew
//
//  Created by Zach Su on 12-07-04.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#define LogInAs @"LogInAs" //Four values: Renren, Facebook, Email, nil
#define FBAccessToken @"AccessToken"
#define FBExpirationDateKey @"ExpirationDateKey"


#define kAppName        @"Whack Who"
#define kCustomMessage  @"I just got a score of %d in %@, an iPhone/iPod Touch game by me!"
#define kServerLink     @"http://indiedevstories.com"
#define kImageSrc       @"http://indiedevstories.files.wordpress.com/2011/08/newsokoban_icon.png"

typedef enum LogInType {
    NotLogIn = 1,
    LogInFacebook,
    LogInRenren,
    LogInEmail
} LogInType;