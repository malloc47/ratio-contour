#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <string>
#include "CmdLine.h"

using namespace std;

vector<double*>* construct_graph(vector<double*> Ltable, vector<double*> Ctable, vector<double*> grad_img, double WIDTH, double LAMBDA1, double LAMBDA2, bool use_corners);
int RC(vector<double*> *graph, int ncount, int ecount, int NumIteration, string fname);

int main(int argc, char** argv) {

   if (argc < 2) {
//      cerr << "Usage: RRC foo [-1 #][-2 #][-n #][-c]\n\tfoo    - image name (PGM without extension)\n\t-1,-2  - real values for lambda, defaults 0.0 (see cost function)\n\t-n     - number of boundaries, default 1\n\t-c     - use corner information, default off\n";
      cerr << "Usage: RRC foo [-1 #][-2 #][-n #][-c]\n\tfoo    - image name (PGM without extension)\n\t-n     - number of boundaries, default 1\n";
      return 1;
   }

   try {
   CmdLine cmd(argc, argv);
   CmdArgInt number =     cmd.parse('n', "number", 1);
   //CmdArgDouble lambda1 = cmd.parse('1', "lambda1", 0.0);
   //CmdArgDouble lambda2 = cmd.parse('2', "lambda2", 0.0);
   //CmdArg use_corners =   cmd.parse('c', "corners");

   /*cout << "Using the following parameters:\nLambda1 = " << lambda1.value() << ", Lambda2 = " << lambda2.value() << ", N = " << number.value() << ", corners = ";
   if (use_corners.isFound()) cout << "on.\n";
   else cout << "off.\n";*/

   int HEIGHT, WIDTH = 0;
   string command;

   string fname = argv[1];
   ifstream lines_in((fname+".lines").c_str());
   if (!lines_in.is_open()) {
      cerr << "ERROR: Could not open file " << fname << ".lines (Forgot to preprocess?)" << endl;
      return 2;
   }
   /*ifstream corners_in((fname+".corners").c_str());
   if (!lines_in.is_open()) {
      cerr << "ERROR: Could not open file " << fname << ".corners" << endl;
      lines_in.close();
      return 2;
   }
   ifstream grad_in((fname+".grad").c_str());
   if (!lines_in.is_open()) {
      cerr << "ERROR: Could not open file " << fname << ".grad" << endl;
      lines_in.close();
      corners_in.close();
      return 2;
   }*/

   vector<double*> lines;
   vector<double*> corners;
   vector<double*> gradient;
   vector<double*> *graph;
   double *one_line, MAX_W2, MAX_W1;
   double *dataout;

   while(!lines_in.eof()) {
   //for (int i=0; i<line_count; i++) {
       one_line = new double[4];
       lines_in >> one_line[0] >> one_line[1] >> one_line[2] >> one_line[3];
       lines.push_back(one_line);      
   }
   lines.pop_back();
   cout << lines.size() << " lines read\n";
   lines_in.close();

   /*while(!corners_in.eof()) {
   //for (int i=0; i<line_count; i++) {
       one_line = new double[3];
       corners_in >> one_line[0] >> one_line[1] >> one_line[2];
       corners.push_back(one_line);      
   }
   corners.pop_back();
   cout << corners.size() << " corners read\n";
   corners_in.close();

   grad_in >> WIDTH >> HEIGHT;
   for (int i=0; i<HEIGHT; i++) {
      one_line = new double[WIDTH];
      for (int j=0; j<WIDTH; j++) 
         grad_in >> one_line[j];
      gradient.push_back(one_line);
   }
   cout << WIDTH << "x" << HEIGHT << " gradient read\n";
   grad_in.close();*/


   graph = construct_graph(lines, corners, gradient, 0, 0, 0, false); //lambda1.value(), lambda2.value(), use_corners.isFound());

   dataout = (*graph)[(*graph).size()-1];
   MAX_W2 = dataout[0];
   MAX_W1 = dataout[1];

   
   (*graph).pop_back();
   delete dataout;

   for (int i = 0; i < (int)(*graph).size(); i++) {
      dataout = (*graph)[i];
      dataout[2] = dataout[2]*600.0/MAX_W2;
      dataout[3] = dataout[3]*600.0/MAX_W1;
   }

   RC(graph, (4*lines.size()), (*graph).size(), number.value(), fname);
   /*if (use_corners.isFound()) {
      command = "mv cornerdata " + fname + ".data";
      system(command.c_str());
   } else {
      command = "rm -fr " + fname + ".data";
      system(command.c_str());
   }*/

   } catch(string msg) {
      cerr << msg << endl;;
      return 1;
   }

   return 0;
}

