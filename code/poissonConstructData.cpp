#include <vector>
#include <utility> // std::pair, make_pair()
#include "mex.h"
#include "matrix.h"

using namespace std;

void mexFunction(int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs != 4) {
		mexErrMsgTxt("Number of input arguments must be 4. \n");
	}

	if (nlhs != 4) {
		mexErrMsgTxt("Number of output arguments must be 4. \n");
	}


	double *im_s = (double *) mxGetPr(prhs[0]);
	bool *mask_s = (bool *) mxGetPr(prhs[1]);
	double *im_background = (double *) mxGetPr(prhs[2]);
	double *im2var = (double *) mxGetPr(prhs[3]);


	const mwSize *size_im_background = mxGetDimensions(prhs[2]);
	const size_t imh = size_im_background[0];
	const size_t imw = size_im_background[1];


	int e = 0;

	vector<double> b(imh*imw), Ay, Ax, Aval;

	for (int y = 0; y < imh; ++y) {
		for (int x = 0; x < imw; ++x) {

			e++;

			// If pixel is not under the mask, copy the target pixel directly
			if (!mask_s[y + x*imh]) {
				// A(e, im2var(y,x)) = 1;
				Ay.push_back(e);
				Ax.push_back(im2var[y + x*imh]);
				Aval.push_back(1);

				b[e-1] = (im_background[y + x*imh]);
			}
			// Pixel not under mask
			else if (mask_s[y + x*imh]) {
				vector<pair<int, int>> neighbours;
				if (x == imw-1 && y == imh-1) {
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x-1));
				} else if (x == 0 && y == 0) {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y, x+1));
				} else if (x == imw-1 && y == 0) {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y, x-1));
				} else if (x == 0 && y == imh-1) {
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x+1));
				} else if (x == 0) {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x+1));
				} else if (y == 0) {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y, x+1));
					neighbours.push_back(make_pair(y, x-1));
				} else if (x == imw-1) {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x-1));
				} else if (y == imh-1) {
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x+1));
					neighbours.push_back(make_pair(y, x-1));
				} else {
					neighbours.push_back(make_pair(y+1, x));
					neighbours.push_back(make_pair(y-1, x));
					neighbours.push_back(make_pair(y, x+1));
					neighbours.push_back(make_pair(y, x-1));
				}


				for (int i = 0; i < neighbours.size(); ++i) {
					int ny = neighbours[i].first;
					int nx = neighbours[i].second;


					// First sum of the blending constraints
					if (mask_s[ny + nx*imh]) {
						Ay.push_back(e);
						Ax.push_back(im2var[y + x*imh]);
						Aval.push_back(1);

						Ay.push_back(e);
						Ax.push_back(im2var[ny + nx*imh]);
						Aval.push_back(-1);

						b[e-1] = b[e-1] + (im_s[y + x*imh] - im_s[ny + nx*imh]);
					}
					// Second sum of the blending constraints
					else {
						Ay.push_back(e);
						Ax.push_back(im2var[y + x*imh]);
						Aval.push_back(1);

						b[e-1] = b[e-1] + (im_s[y + x*imh] - im_s[ny + nx*imh]) + im_background[ny + nx*imh];
					}
				}
			}
			
		}
	}

	// mexPrintf("size(Ay) = %d;\nsize(Ax) = %d;\nsize(Aval) = %d;\nsize(b) = %d;\n", Ay.size(), Ax.size(), Aval.size(), b.size());


	// Return data back to MATLAB

	// Ay
	plhs[0] = mxCreateNumericMatrix(Ay.size(), 1, mxDOUBLE_CLASS, mxREAL);
	double *Ay_ptr = &Ay[0];
	double *Ay_out = (double *) mxGetPr(plhs[0]);
	memcpy(Ay_out, Ay_ptr, sizeof(double) * Ay.size());

	// Ax
	plhs[1] = mxCreateNumericMatrix(Ax.size(), 1, mxDOUBLE_CLASS, mxREAL);
	double *Ax_ptr = &Ax[0];
	double *Ax_out = (double *) mxGetPr(plhs[1]);
	memcpy(Ax_out, Ax_ptr, sizeof(double) * Ax.size());

	// Aval
	plhs[2] = mxCreateNumericMatrix(Aval.size(), 1, mxDOUBLE_CLASS, mxREAL);
	double *Aval_ptr = &Aval[0];
	double *Aval_out = (double *) mxGetPr(plhs[2]);
	memcpy(Aval_out, Aval_ptr, sizeof(double) * Aval.size());

	// b
	plhs[3] = mxCreateNumericMatrix(b.size(), 1, mxDOUBLE_CLASS, mxREAL);
	double *b_ptr = &b[0];
	double *b_out = (double *) mxGetPr(plhs[3]);
	memcpy(b_out, b_ptr, sizeof(double) * b.size());

}