#include <string>
#include <iostream>
#include <cstdio>
#include "CmdLine.h"

using namespace std;

int main(int argc, char** argv) {

   try {
   CmdLine cmd(argc, argv);
   CmdArgInt number =     cmd.parse('n', "number", 1);
   CmdArgDouble lambda1 = cmd.parse('1', "lambda1", 0.0);
   CmdArgDouble lambda2 = cmd.parse('2', "lambda2", 0.0);
   CmdArg use_corners =   cmd.parse('c', "corners");

   char params[100];

   string fname, base = "time ./RRC ", command;

   snprintf(params, sizeof(params), " -1 %g -2 %g -n %d",lambda1.value(), lambda2.value(), number.value());

   for (int i=1; i < argc; i++) {

      fname = argv[i];
      if (fname[0] == '-') {
         if (fname[1] != 'c') i++;
         continue;
      }
      command = base + fname.substr(0,fname.size()-4) + params;
      if (use_corners.isFound())
         command += " -c";
      cout << command << endl;
      system( command.c_str() );

   }

   }
   catch(string msg) {
      cerr << msg << endl;
   }

}
