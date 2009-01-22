//
//  TynsoeClasses.h
//  SSH Tunnel Manager 2
//
//  Created by Yann Bizeul on Thu Nov 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TVersionTextField : NSTextField {
 }
@end

@interface TLinkTextField : NSTextField {
    NSString *url;  
}
-(void)setURL:(NSString*)theURL;
@end
