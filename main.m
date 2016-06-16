function out = model
%
% compacted.m
%
% Model exported on Jun 16 2016, 15:46 by COMSOL 5.2.0.220.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/zhetao/Research/Array_Absorption_Optimization');

model.label('my_normal_absorption_v2_optimization.mph');

model.comments(['My normal absorption\n\n']);

model.param.set('a', '0.0003[m]');
model.param.set('b', '0.26');
model.param.set('D', '0.04[m]');
model.param.set('d', 'period/4');
model.param.set('theta_i', '0*pi/180');
model.param.set('freq0', '3e3[Hz]');
model.param.set('lambda', '343[m/s]/freq0');
model.param.set('W', '2*R');
model.param.set('loss', '0.1');
model.param.set('R', '50*d');
model.param.set('zr', '1');
model.param.set('theta_r', '20*pi/180');
model.param.set('period', 'lambda*0.85');
model.param.set('d_nr_max', '3');
model.param.set('loss_a', '0.00');
model.param.set('nop', '20');
model.param.set('sigma', '0.3');
model.param.set('PMLH', '0.1');
model.param.set('c1', '0.30573');
model.param.set('c3', '0.28936');
model.param.set('c2', '0');
model.param.set('x0', '0.04905');

model.modelNode.create('comp1');

model.geom.create('geom1', 2);

model.modelNode.create('comp2');

model.geom.create('geom2', 2);

model.modelNode('comp1').defineLocalCoord(false);
model.modelNode('comp2').defineLocalCoord(false);

model.func.create('wv1', 'Wave');
model.func.create('an2', 'Analytic');
model.func('wv1').model('comp1');
model.func('wv1').label('Defined function for index change');
model.func('wv1').set('type', 'sawtooth');
model.func('wv1').set('freq', '2*pi/period');
model.func('wv1').set('ncontder', '1');
model.func('wv1').set('amplitude', 'd_nr_max/2');
model.func('wv1').set('smooth', '0.001');
model.func('wv1').set('funcname', 'd_nr');
model.func('an2').model('comp1');
model.func('an2').label('Refractive index function');
model.func('an2').set('expr', '1+d_nr_max/2+d_nr(x)+c1*sin(pi/period*(x-x0))+c3*sin(3*pi/period*(x-x0))');
model.func('an2').set('funcname', 'nr');

model.mesh.create('mesh3', 'geom1');
model.mesh.create('mesh4', 'geom2');

model.geom('geom1').selection.create('csel1', 'CumulativeSelection');
model.geom('geom1').selection('csel1').label('PML');
model.geom('geom1').selection.create('csel2', 'CumulativeSelection');
model.geom('geom1').selection('csel2').label('metasurface region');
model.geom('geom1').selection.create('csel3', 'CumulativeSelection');
model.geom('geom1').selection('csel3').label('air');
model.geom('geom1').create('c1', 'Circle');
model.geom('geom1').feature('c1').set('pos', {'0' '0'});
model.geom('geom1').feature('c1').set('r', 'R');
model.geom('geom1').feature('c1').set('contributeto', 'csel3');
model.geom('geom1').feature('c1').set('angle', '180');
model.geom('geom1').create('r2', 'Rectangle');
model.geom('geom1').feature('r2').set('size', {'period*nop' '0.5'});
model.geom('geom1').feature('r2').set('contributeto', 'csel2');
model.geom('geom1').feature('r2').set('pos', {'-period*nop/2' '0'});
model.geom('geom1').create('r4', 'Rectangle');
model.geom('geom1').feature('r4').set('size', {'d' 'D'});
model.geom('geom1').feature('r4').set('pos', {'-period*nop/2' '0'});
model.geom('geom1').create('arr2', 'Array');
model.geom('geom1').feature('arr2').set('displ', {'d' '0'});
model.geom('geom1').feature('arr2').set('size', {'period/d*nop' '1'});
model.geom('geom1').feature('arr2').selection('input').set({'r4'});
model.geom('geom1').create('r5', 'Rectangle');
model.geom('geom1').feature('r5').set('size', {'W' 'PMLH'});
model.geom('geom1').feature('r5').set('base', 'center');
model.geom('geom1').feature('r5').set('pos', {'0' '-0.5*PMLH'});
model.geom('geom1').run;
model.geom('geom1').run('fin');
model.geom('geom2').create('c1', 'Circle');
model.geom('geom2').feature('c1').set('r', 'R');
model.geom('geom2').feature('c1').set('angle', '180');
model.geom('geom2').create('r2', 'Rectangle');
model.geom('geom2').feature('r2').set('size', {'period*nop' '0.5'});
model.geom('geom2').feature('r2').set('pos', {'-period*nop/2' '0'});
model.geom('geom2').create('r3', 'Rectangle');
model.geom('geom2').feature('r3').set('size', {'W' 'PMLH'});
model.geom('geom2').feature('r3').set('base', 'center');
model.geom('geom2').feature('r3').set('pos', {'0' '-0.5*PMLH'});
model.geom('geom2').create('r4', 'Rectangle');
model.geom('geom2').feature('r4').set('size', {'period*nop' 'D'});
model.geom('geom2').feature('r4').set('pos', {'-period*nop/2' '0'});
model.geom('geom2').run;
model.geom('geom2').run('fin');

model.variable.create('var2');
model.variable('var2').model('comp1');
model.variable('var2').set('p_with', '1/2*real(-intup1(acpr.p_t*conj(acpr.vy))+intleft1(acpr.p_t*conj(acpr.vx))-intright1(acpr.p_t*conj(acpr.vx)))');
model.variable.create('var3');
model.variable('var3').model('comp2');
model.variable('var3').set('p_without', '1/2*real(-intup2(acpr2.p_t*conj(acpr2.vy))+intleft2(acpr2.p_t*conj(acpr2.vx))-intright2(acpr2.p_t*conj(acpr2.vx)))');

model.view('view2').tag('view3');

model.material.create('mat1', 'Common', 'comp1');
model.material.create('mat2', 'Common', 'comp1');
model.material.create('mat4', 'Common', 'comp2');
model.material.create('mat5', 'Common', 'comp2');
model.material.create('mat6', 'Common', 'comp1');
model.material('mat2').selection.set([3 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83]);
model.material('mat4').selection.set([2 3 4]);
model.material('mat5').selection.set([1]);
model.material('mat6').selection.set([1]);

model.cpl.create('intop1', 'Integration', 'geom1');
model.cpl.create('intop2', 'Integration', 'geom2');
model.cpl.create('intop3', 'Integration', 'geom1');
model.cpl.create('intop4', 'Integration', 'geom1');
model.cpl.create('intop5', 'Integration', 'geom2');
model.cpl.create('intop6', 'Integration', 'geom2');
model.cpl('intop1').selection.geom('geom1', 1);
model.cpl('intop1').selection.set([8]);
model.cpl('intop2').selection.geom('geom2', 1);
model.cpl('intop2').selection.set([8]);
model.cpl('intop3').selection.geom('geom1', 1);
model.cpl('intop3').selection.set([6]);
model.cpl('intop4').selection.geom('geom1', 1);
model.cpl('intop4').selection.set([248]);
model.cpl('intop5').selection.geom('geom2', 1);
model.cpl('intop5').selection.set([4 6]);
model.cpl('intop6').selection.geom('geom2', 1);
model.cpl('intop6').selection.set([10 12]);

model.coordSystem.create('pml1', 'geom1', 'PML');
model.coordSystem.create('pml2', 'geom2', 'PML');
model.coordSystem('pml1').selection.set([1]);
model.coordSystem('pml2').selection.set([1]);

model.physics.create('acpr', 'PressureAcoustics', 'geom1');
model.physics('acpr').create('pwr1', 'PlaneWaveRadiation', 1);
model.physics('acpr').feature('pwr1').selection.set([250 251]);
model.physics('acpr').feature('pwr1').create('ipf1', 'IncidentPressureField', 1);
model.physics('acpr').feature('pwr1').feature('ipf1').selection.set([7 11 12 14 15 17 18 20 21 23 24 26 27 29 30 32 33 35 36 38 39 41 42 44 45 47 48 50 51 53 54 56 57 59 60 62 63 65 66 68 69 71 72 74 75 77 78 80 81 83 84 86 87 89 90 92 93 95 96 98 99 101 102 104 105 107 108 110 111 113 114 116 117 119 120 122 123 125 126 128 129 131 132 134 135 137 138 140 141 143 144 146 147 149 150 152 153 155 156 158 159 161 162 164 165 167 168 170 171 173 174 176 177 179 180 182 183 185 186 188 189 191 192 194 195 197 198 200 201 203 204 206 207 209 210 212 213 215 216 218 219 221 222 224 225 227 228 230 231 233 234 236 237 239 240 242 243 245 246 250 251]);
model.physics('acpr').create('ishb1', 'InteriorSoundHard', 1);
model.physics('acpr').feature('ishb1').selection.set([4 5 9 10 12 13 15 16 18 19 21 22 24 25 27 28 30 31 33 34 36 37 39 40 42 43 45 46 48 49 51 52 54 55 57 58 60 61 63 64 66 67 69 70 72 73 75 76 78 79 81 82 84 85 87 88 90 91 93 94 96 97 99 100 102 103 105 106 108 109 111 112 114 115 117 118 120 121 123 124 126 127 129 130 132 133 135 136 138 139 141 142 144 145 147 148 150 151 153 154 156 157 159 160 162 163 165 166 168 169 171 172 174 175 177 178 180 181 183 184 186 187 189 190 192 193 195 196 198 199 201 202 204 205 207 208 210 211 213 214 216 217 219 220 222 223 225 226 228 229 231 232 234 235 237 238 240 241 243 244 246]);
model.physics.create('acpr2', 'PressureAcoustics', 'geom2');
model.physics('acpr2').create('pwr1', 'PlaneWaveRadiation', 1);
model.physics('acpr2').feature('pwr1').selection.set([14 15]);
model.physics('acpr2').feature('pwr1').create('ipf1', 'IncidentPressureField', 1);
model.physics('acpr2').feature('pwr1').feature('ipf1').selection.set([14 15]);

model.mesh('mesh3').autoMeshSize(2);
model.mesh('mesh4').autoMeshSize(2);

model.result.table.create('tbl1', 'Table');
model.result.table.create('tbl3', 'Table');

model.ode.create('conpar4');
model.ode.create('conpar8');
model.ode.create('conpar9');

model.variable('var2').label('With array');
model.variable('var3').label('Without array');

model.view('view1').axis.set('abstractviewxscale', '0.003228283254429698');
model.view('view1').axis.set('ymin', '-0.17279952764511108');
model.view('view1').axis.set('xmax', '1.2755311727523804');
model.view('view1').axis.set('abstractviewyscale', '0.003228283254429698');
model.view('view1').axis.set('abstractviewbratio', '-0.06281674653291702');
model.view('view1').axis.set('abstractviewtratio', '0.06281674653291702');
model.view('view1').axis.set('abstractviewrratio', '0.04999999329447746');
model.view('view1').axis.set('xmin', '-1.2755311727523804');
model.view('view1').axis.set('abstractviewlratio', '-0.04999999329447746');
model.view('view1').axis.set('ymax', '1.2875912189483643');
model.view('view3').label('View 3');
model.view('view3').axis.set('abstractviewxscale', '0.003228283254429698');
model.view('view3').axis.set('ymin', '-0.10763049125671387');
model.view('view3').axis.set('xmax', '1.2961556911468506');
model.view('view3').axis.set('abstractviewyscale', '0.003228283254429698');
model.view('view3').axis.set('abstractviewbratio', '-0.06281674653291702');
model.view('view3').axis.set('abstractviewtratio', '0.06281674653291702');
model.view('view3').axis.set('abstractviewrratio', '0.04999999329447746');
model.view('view3').axis.set('xmin', '-1.2961556911468506');
model.view('view3').axis.set('abstractviewlratio', '-0.04999999329447746');
model.view('view3').axis.set('ymax', '1.2224221229553223');

model.material('mat1').propertyGroup('def').set('density', '1.25*(1-loss_a*i)');
model.material('mat1').propertyGroup('def').set('soundspeed', '343/(1-loss_a*i)');
model.material('mat2').propertyGroup('def').set('density', '1.25*nr(x)*(1-loss*i)');
model.material('mat2').propertyGroup('def').set('soundspeed', '343/nr(x)/sqrt(1-loss*i)');
model.material('mat4').label('Air');
model.material('mat4').propertyGroup('def').set('density', '1.25*(1-loss_a*i)');
model.material('mat4').propertyGroup('def').set('soundspeed', '343/(1-loss_a*i)');
model.material('mat5').label('Perfectly Matched');
model.material('mat5').propertyGroup('def').set('density', '1.25');
model.material('mat5').propertyGroup('def').set('soundspeed', '343');
model.material('mat6').propertyGroup('def').set('density', '1.25');
model.material('mat6').propertyGroup('def').set('soundspeed', '343');

model.cpl('intop1').label('Integration up');
model.cpl('intop1').set('opname', 'intup1');
model.cpl('intop2').label('Integration up 2');
model.cpl('intop2').set('opname', 'intup2');
model.cpl('intop3').label('Integration left');
model.cpl('intop3').set('opname', 'intleft1');
model.cpl('intop4').label('Integration right');
model.cpl('intop4').set('opname', 'intright1');
model.cpl('intop5').label('Integration left 2');
model.cpl('intop5').set('opname', 'intleft2');
model.cpl('intop6').label('Integration right 2');
model.cpl('intop6').set('opname', 'intright2');

model.physics('acpr').feature('pwr1').feature('ipf1').set('IncidentPressureFieldType', 'UserDefined');
model.physics('acpr').feature('pwr1').feature('ipf1').set('dir', {'sin(theta_i)'; '-cos(theta_i)'; '0'});
model.physics('acpr').feature('pwr1').feature('ipf1').set('p_i', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(sigma^2))*exp(-1i*acpr.k*(sin(theta_i)*x-cos(theta_i)*y))');
model.physics('acpr').feature('pwr1').feature('ipf1').set('pamp', 'exp(-((y-0.4+D/2-(25*0.025685-0.4*tan(theta_i))/tan(theta_i))/0.5)^2)');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('IncidentPressureFieldType', 'UserDefined');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('dir', {'sin(theta_i)'; '-cos(theta_i)'; '0'});
model.physics('acpr2').feature('pwr1').feature('ipf1').set('p_i', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(sigma^2))*exp(-1i*acpr2.k*(sin(theta_i)*x-cos(theta_i)*y))');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('pamp', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(0.5^2))*exp(-1i*acpr.k*(sin(theta_i)*x-cos(theta_i)*y))');

model.mesh('mesh3').run;
model.mesh('mesh4').run;

model.result.table('tbl1').comments('Global Evaluation 1 (comp1.p_with/comp2.p_without/26)');
model.result.table('tbl3').label('Objective Table 3');

model.ode('conpar4').state({'c1'});
model.ode('conpar8').state({'c3'});
model.ode('conpar9').state({'x0'});

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study.create('std2');
model.study('std2').create('freq', 'Frequency');
model.study('std2').feature('freq').set('activate', {'acpr' 'on' 'acpr2' 'off'});
model.study.create('std3');
model.study('std3').create('freq', 'Frequency');
model.study('std3').feature('freq').set('activate', {'acpr' 'off' 'acpr2' 'on'});
model.study.create('std4');
model.study('std4').create('opt', 'Optimization');
model.study('std4').create('freq', 'Frequency');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol.create('sol2');
model.sol('sol2').study('std2');
model.sol('sol2').attach('std2');
model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').create('s1', 'Stationary');
model.sol('sol2').feature('s1').create('p1', 'Parametric');
model.sol('sol2').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('s1').feature.remove('fcDef');
model.sol.create('sol3');
model.sol('sol3').study('std3');
model.sol('sol3').attach('std3');
model.sol('sol3').create('st1', 'StudyStep');
model.sol('sol3').create('v1', 'Variables');
model.sol('sol3').create('s1', 'Stationary');
model.sol('sol3').feature('s1').create('p1', 'Parametric');
model.sol('sol3').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol3').feature('s1').feature.remove('fcDef');
model.sol.create('sol4');
model.sol('sol4').study('std4');
model.sol('sol4').attach('std4');
model.sol('sol4').create('st1', 'StudyStep');
model.sol('sol4').create('v1', 'Variables');
model.sol('sol4').create('s1', 'Stationary');
model.sol('sol4').feature('s1').create('p1', 'Parametric');
model.sol('sol4').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol4').feature('s1').feature.remove('fcDef');

model.batch.create('o1', 'Optimization');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('o1').study('std4');
model.batch('p1').study('std4');

model.result.dataset.create('an2_ds1', 'Grid1D');
model.result.dataset('an2_ds1').set('data', 'none');
model.result.dataset('dset2').set('solution', 'sol4');
model.result.dataset.remove('dset3');
model.result.dataset.remove('dset4');
model.result.dataset.remove('dset5');
model.result.dataset.remove('dset6');
model.result.dataset.remove('dset7');
model.result.dataset.remove('dset8');
model.result.numerical.create('gev1', 'EvalGlobal');
model.result.numerical('gev1').set('probetag', 'none');
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup1D');
model.result.create('pg4', 'PlotGroup2D');
model.result.create('pg5', 'PlotGroup2D');
model.result('pg1').create('surf1', 'Surface');
model.result('pg2').create('surf1', 'Surface');
model.result('pg3').create('plot1', 'LineGraph');
model.result('pg3').feature('plot1').set('xdata', 'expr');
model.result('pg4').set('data', 'dset2');
model.result('pg4').create('surf1', 'Surface');
model.result('pg5').set('data', 'dset2');
model.result('pg5').create('surf1', 'Surface');

model.study('std1').label('Combined');
model.study('std1').feature('freq').set('plist', 'range(500,100,3000)');
model.study('std2').label('comp1');
model.study('std2').feature('freq').set('plist', '3000');
model.study('std3').label('comp2');
model.study('std3').feature('freq').set('plist', 'range(500,20,3000)');
model.study('std4').label('Optimization');
model.study('std4').feature('opt').label('Optimization 2');
model.study('std4').feature('opt').set('probesel', 'none');
model.study('std4').feature('opt').set('lbound', {'0.23' '0.2' '0.02'});
model.study('std4').feature('opt').set('scale', {'1' '1' '1'});
model.study('std4').feature('opt').set('objectivetype', 'maximization');
model.study('std4').feature('opt').set('pname', {'c1' 'c3' 'x0'});
model.study('std4').feature('opt').set('ubound', {'0.5' '0.5' '0.07'});
model.study('std4').feature('opt').set('objtable', 'tbl3');
model.study('std4').feature('opt').set('optobj', {'comp1.p_with/comp2.p_without/26'});
model.study('std4').feature('opt').set('descr', {''});
model.study('std4').feature('opt').set('nsolvemax', '100');
model.study('std4').feature('opt').set('initval', {'0.30573' '0.28936' '0.04905'});
model.study('std4').feature('opt').set('optobjEvaluateFor', {'freq'});
model.study('std4').feature('freq').set('plist', 'range(500,100,3000)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'range(500,100,3000)'});
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').runAll;
model.sol('sol2').attach('std2');
model.sol('sol2').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol2').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol2').feature('s1').feature('p1').set('plistarr', {'3000'});
model.sol('sol2').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol2').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol2').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol2').runAll;
model.sol('sol3').attach('std3');
model.sol('sol3').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol3').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol3').feature('s1').feature('p1').set('plistarr', {'range(500,20,3000)'});
model.sol('sol3').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol3').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol3').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol3').runAll;
model.sol('sol4').attach('std4');
model.sol('sol4').feature('v1').feature('comp2_p2').label('comp2.p2');
model.sol('sol4').feature('v1').feature('comp1_p').label('comp1.p');
model.sol('sol4').feature('v1').feature('conpar4').label('conpar4');
model.sol('sol4').feature('v1').feature('conpar8').label('conpar8');
model.sol('sol4').feature('v1').feature('conpar9').label('conpar9');
model.sol('sol4').feature('s1').set('probesel', 'none');
model.sol('sol4').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol4').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol4').feature('s1').feature('p1').set('plistarr', {'range(500,100,3000)'});
model.sol('sol4').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol4').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol4').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol4').runAll;

model.batch('p1').set('probesel', 'none');
model.batch('p1').set('err', true);
model.batch('p1').set('plistarr', {'0.29986133244231117' '0.2909834565773322' '0.04950793356702737'});
model.batch('p1').set('pname', {'c1' 'c3' 'x0'});
model.batch('p1').set('control', 'opt');
model.batch('p1').feature('so1').set('seq', 'sol4');
model.batch('o1').attach('std4');
model.batch('o1').run;

model.result.dataset('an2_ds1').set('function', 'all');
model.result.numerical('gev1').set('table', 'tbl1');
model.result.numerical('gev1').set('unit', '1');
model.result.numerical('gev1').set('expr', 'comp1.p_with/comp2.p_without/26');
model.result.numerical('gev1').set('descr', 'comp1.p_with/comp2.p_without/26');
model.result.numerical('gev1').setResult;
model.result('pg1').label('Acoustic Pressure (acpr)');
model.result('pg1').set('looplevel', {'25'});
model.result('pg2').label('Sound Pressure Level (acpr)');
model.result('pg2').set('looplevel', {'25'});
model.result('pg2').feature('surf1').set('expr', 'acpr.Lp');
model.result('pg2').feature('surf1').set('descr', 'Sound pressure level');
model.result('pg2').feature('surf1').set('unit', 'dB');
model.result('pg3').set('data', 'none');
model.result('pg3').set('title', 'nr(x)');
model.result('pg3').set('ylabelactive', true);
model.result('pg3').set('xlabelactive', true);
model.result('pg3').set('titletype', 'manual');
model.result('pg3').feature('plot1').set('data', 'an2_ds1');
model.result('pg3').feature('plot1').set('xdataunit', '');
model.result('pg3').feature('plot1').set('solrepresentation', 'solnum');
model.result('pg3').feature('plot1').set('expr', 'comp1.nr(root.x)');
model.result('pg3').feature('plot1').set('xdatadescr', 'x-coordinate');
model.result('pg3').feature('plot1').set('xdataexpr', 'root.x');
model.result('pg3').feature('plot1').set('descr', 'nr(x)');
model.result('pg3').feature('plot1').set('unit', '');
model.result('pg3').feature('plot1').set('xdataunit', '');
model.result('pg4').label('Acoustic Pressure (acpr) 1');
model.result('pg5').label('Sound Pressure Level (acpr) 1');
model.result('pg5').feature('surf1').set('expr', 'acpr.Lp');
model.result('pg5').feature('surf1').set('descr', 'Sound pressure level');
model.result('pg5').feature('surf1').set('unit', 'dB');

out = model;
