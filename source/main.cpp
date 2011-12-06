#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <string>
#include "CmdLine.h"

using namespace std;

vector<double*>* construct_graph(vector<double*> Ltable, vector<double*> Ctable, vector<double*> grad_img, double WIDTH, double LAMBDA, bool homogeneity, bool use_corners, string datafile, double ALPHA);
int RC(vector<double*> *graph, int ncount, int ecount, int NumIteration, string fname);

int main(int argc, char** argv) {

   if (argc < 2) {
      cerr << "Usage: RRC foo.pgm [-n #][-l #][-c][-h][-a #]\n\tfoo.pgm - image to be processed.\n\t-n      - number of boundaries (default 1).\n\t-l      - real value for continuity lambda (default 0.0).\n\t-c      - use corner information.\n\t-h      - use homogeneity instead of area.\n\t-a      - exponent alpha for proximity (default 1.0).\n";
      return 1;
   }

   try {
   CmdLine cmd(argc, argv);
   CmdArgInt number =    cmd.parse('n', "number", 1);
   CmdArgDouble lambda = cmd.parse('l', "lambda", 0.0);
   CmdArg homogeneity =  cmd.parse('h', "homogeneity");
   CmdArg use_corners =  cmd.parse('c', "corners");
   CmdArgDouble alpha =  cmd.parse('a', "alpha", 1.0);

   string fname = argv[1];
   if (fname.substr(fname.length()-4, fname.length()) == ".pgm")
      fname = fname.substr(0,fname.length()-4);
   cout << "Processing: " << fname << endl;

   if (lambda.value() < 0) {
      cerr << "Warning: Lambda should be a real positive value.\n Using default value of 0.0.\n";
      lambda.setValue(0.0);
   }

   cout << "Using the following parameters:\nLambda = " << lambda.value() << ", N = " << number.value() << ", corners = ";
   if (use_corners.isFound()) cout << "on, homogeneity = ";
   else cout << "off, homogeneity = ";
   if (homogeneity.isFound()) cout << "on, alpha = ";
   else cout << "off, alpha = ";
   cout << alpha.value() << ".\n";

   int HEIGHT, WIDTH = 0;

   ifstream lines_in((fname+".lines").c_str());
   if (!lines_in.is_open()) {
      cerr << "ERROR: Could not open file " << fname << ".lines (Forgot to preprocess?)" << endl;
      return 2;
   }

   ifstream corners_in, grad_in;

   if (use_corners.isFound()) {
      corners_in.open((fname+".corners").c_str());
      if (!lines_in.is_open()) {
         cerr << "ERROR: Could not open file " << fname << ".corners" << endl;
         lines_in.close();
         return 2;
      }
   }
   if (homogeneity.isFound()) {
      grad_in.open((fname+".map").c_str());
      if (!lines_in.is_open()) {
         cerr << "ERROR: Could not open file " << fname << ".map" << endl;
         lines_in.close();
         corners_in.close();
         return 2;
      }
   }

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

   if (use_corners.isFound()) {
      while(!corners_in.eof()) {
      //for (int i=0; i<line_count; i++) {
         one_line = new double[3];
         corners_in >> one_line[0] >> one_line[1] >> one_line[2];
         corners.push_back(one_line);      
      }
      corners.pop_back();
      cout << corners.size() << " corners read\n";
      corners_in.close();
   }

   if (homogeneity.isFound()) {
      grad_in >> WIDTH >> HEIGHT;
      for (int i=0; i<HEIGHT; i++) {
         one_line = new double[WIDTH];
         for (int j=0; j<WIDTH; j++) 
            grad_in >> one_line[j];
         gradient.push_back(one_line);
      }
      cout << WIDTH << "x" << HEIGHT << " gradient read\n";
      grad_in.close();
   }

   graph = construct_graph(lines, corners, gradient, WIDTH, lambda.value(), homogeneity.isFound(), use_corners.isFound(), fname+".data", alpha.value());

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

   } catch(string msg) {
      cerr << msg << endl;;
      return 1;
   }

   return 0;
}

