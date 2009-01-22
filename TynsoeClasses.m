//
//  TynsoeClasses.m
//  SSH Tunnel Manager 2
//
//  Created by Yann Bizeul on Thu Nov 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "TynsoeClasses.h"


@implementation TVersionTextField
- (void)awakeFromNib
{
    NSString *originalString = [ self stringValue ];
    [ self setStringValue: [ NSString stringWithFormat: originalString,
	[[ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleShortVersionString" ],
        [[[ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleVersion" ] intValue ]]
	];
}
@end

@implementation TLinkTextField
-(void)setURL:(NSString*)theURL
{
    [ url release ];
    url = [ theURL retain ];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [[ NSWorkspace sharedWorkspace ] openURL: [ NSURL URLWithString: url]];
}
@end
