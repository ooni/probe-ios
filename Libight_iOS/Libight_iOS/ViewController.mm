//
//  ViewController.m
//  test8
//
//  Created by Simone Basso on 18/01/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "ViewController.h"

/*Include header from dns_injection test*/
#include "ooni/dns_injection.hpp"
#include "common/poller.h"
#include "common/log.h"
#include "common/utils.hpp"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changelabel:(id)sender {
    
    
    
    /*DNS_INJECTION TEST*/
    ight_set_verbose(1);
    ight::common::Settings options;
    options["nameserver"] = "8.8.8.8:53";
    ight::ooni::dns_injection::DNSInjection dns_injection("/Users/simonebasso/Documents/Libight_iOS/Libight_iOS/Resources/fixtures/hosts.txt", options);
    dns_injection.begin([&](){
        dns_injection.end([](){
            ight_break_loop();
        });
    });
    ight_loop();
    
    _label.text = @"Test eseguito!";
}

@end
