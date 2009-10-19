//
//  HeyPlugin.m
//  HeyPlugin
//
//  Created by Mike! on 10/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HeyPlugin.h"
#import <Adium/AIListObject.h>
#import <Adium/AIContentMessage.h>
#import <Adium/AIChat.h>
#import <Adium/AIContactAlertsControllerProtocol.h>
#import <Adium/AIMetaContact.h>

@implementation HeyPlugin

- (NSString *)pluginAuthor
{
	return @"Mike Ryan";
}

- (NSString *)pluginVersion
{
	return @"1.0";
}

- (NSString *)pluginDescription
{
	return @"Raises the 'Notification Received' event when we receive a message that starts with '/hey'";
}

- (NSString *)pluginURL
{
	return @"http://falter.net";
}

- (void)installPlugin
{
	//Register our filter so that was can watch for our key.
    [adium.contentController registerContentFilter:self
											ofType:AIFilterContent 
										 direction:AIFilterIncoming];
}

- (void)uninstallPlugin
{
	//Unregister our filter.
    [adium.contentController unregisterContentFilter:self];
}


- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context;
{
	//If we aren't filtering a chat window, then skip it!
	if(!([context isKindOfClass:[AIContentMessage class]] && 
  	    [[context destination] isKindOfClass:[AIListObject class]]))
		return inAttributedString;
	
	//If our chat message starts with '/hey', then 
	if ([[inAttributedString string] rangeOfString:@"/hey"].location == 0)
	{
		AIChat *chat = ((AIContentMessage *)context).chat;
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:chat, @"AIChat", context , @"AIContentObject", nil];
		
		//Shoot our event over, using the "Notification Received" event. We're
		//co-opting the /nudge support for this.
		[adium.contactAlertsController generateEvent:CONTENT_NUDGE_BUZZ_OCCURED
									   forListObject:chat.listObject
											userInfo:userInfo
						previouslyPerformedActionIDs:nil];
		
		return nil;
	}
	
	return inAttributedString;
}

- (CGFloat)filterPriority
{
	return LOWEST_FILTER_PRIORITY;
}

@end
