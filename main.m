function out = model
%
% main.m
%
% Model exported on Jun 18 2016, 14:25 by COMSOL 5.2.0.220.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/zhetao/Research/Array_absorption_git');

model.label('optimization.mph');

model.comments('Optimization\n\nMy normal absorption\n\n');

model.param.set('a', '0.0003[m]');
model.param.set('b', '0.26');
model.param.set('D', '0.04[m]');
model.param.set('d', 'period/8');
model.param.set('theta_i', '0*pi/180');
model.param.set('freq0', '3e3[Hz]');
model.param.set('lambda', '343[m/s]/freq0');
model.param.set('W', '2*R');
model.param.set('loss', '0.1');
model.param.set('R', '100*d');
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
model.func('an2').set('expr', '1+d_nr_max/2+d_nr(x)+c1*cos(pi/period*(x))+c3*cos(3*pi/period*(x))');
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

model.selection.create('box1', 'Box');
model.selection('box1').model('comp1');
model.selection('box1').set('entitydim', '1');
model.selection('box1').set('xmin', '-1');
model.selection('box1').set('ymax', '0.02');
model.selection('box1').set('ymin', '-0.05');
model.selection('box1').set('xmax', '1');

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
model.material('mat2').selection.set([3 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163]);
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
model.cpl('intop1').selection.set([6 8 488]);
model.cpl('intop2').selection.geom('geom2', 1);
model.cpl('intop2').selection.set([8]);
model.cpl('intop3').selection.geom('geom1', 1);
model.cpl('intop4').selection.geom('geom1', 1);
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
model.physics('acpr').feature('pwr1').selection.set([490 491]);
model.physics('acpr').feature('pwr1').create('ipf1', 'IncidentPressureField', 1);
model.physics('acpr').feature('pwr1').feature('ipf1').selection.set([7 11 12 14 15 17 18 20 21 23 24 26 27 29 30 32 33 35 36 38 39 41 42 44 45 47 48 50 51 53 54 56 57 59 60 62 63 65 66 68 69 71 72 74 75 77 78 80 81 83 84 86 87 89 90 92 93 95 96 98 99 101 102 104 105 107 108 110 111 113 114 116 117 119 120 122 123 125 126 128 129 131 132 134 135 137 138 140 141 143 144 146 147 149 150 152 153 155 156 158 159 161 162 164 165 167 168 170 171 173 174 176 177 179 180 182 183 185 186 188 189 191 192 194 195 197 198 200 201 203 204 206 207 209 210 212 213 215 216 218 219 221 222 224 225 227 228 230 231 233 234 236 237 239 240 242 243 245 246 248 249 251 252 254 255 257 258 260 261 263 264 266 267 269 270 272 273 275 276 278 279 281 282 284 285 287 288 290 291 293 294 296 297 299 300 302 303 305 306 308 309 311 312 314 315 317 318 320 321 323 324 326 327 329 330 332 333 335 336 338 339 341 342 344 345 347 348 350 351 353 354 356 357 359 360 362 363 365 366 368 369 371 372 374 375 377 378 380 381 383 384 386 387 389 390 392 393 395 396 398 399 401 402 404 405 407 408 410 411 413 414 416 417 419 420 422 423 425 426 428 429 431 432 434 435 437 438 440 441 443 444 446 447 449 450 452 453 455 456 458 459 461 462 464 465 467 468 470 471 473 474 476 477 479 480 482 483 485 490 491]);
model.physics('acpr').create('ishb1', 'InteriorSoundHard', 1);
model.physics('acpr').feature('ishb1').selection.set([4 5 9 10 12 13 15 16 18 19 21 22 24 25 27 28 30 31 33 34 36 37 39 40 42 43 45 46 48 49 51 52 54 55 57 58 60 61 63 64 66 67 69 70 72 73 75 76 78 79 81 82 84 85 87 88 90 91 93 94 96 97 99 100 102 103 105 106 108 109 111 112 114 115 117 118 120 121 123 124 126 127 129 130 132 133 135 136 138 139 141 142 144 145 147 148 150 151 153 154 156 157 159 160 162 163 165 166 168 169 171 172 174 175 177 178 180 181 183 184 186 187 189 190 192 193 195 196 198 199 201 202 204 205 207 208 210 211 213 214 216 217 219 220 222 223 225 226 228 229 231 232 234 235 237 238 240 241 243 244 246 247 249 250 252 253 255 256 258 259 261 262 264 265 267 268 270 271 273 274 276 277 279 280 282 283 285 286 288 289 291 292 294 295 297 298 300 301 303 304 306 307 309 310 312 313 315 316 318 319 321 322 324 325 327 328 330 331 333 334 336 337 339 340 342 343 345 346 348 349 351 352 354 355 357 358 360 361 363 364 366 367 369 370 372 373 375 376 378 379 381 382 384 385 387 388 390 391 393 394 396 397 399 400 402 403 405 406 408 409 411 412 414 415 417 418 420 421 423 424 426 427 429 430 432 433 435 436 438 439 441 442 444 445 447 448 450 451 453 454 456 457 459 460 462 463 465 466 468 469 471 472 474 475 477 478 480 481 483 484 486]);
model.physics.create('acpr2', 'PressureAcoustics', 'geom2');
model.physics('acpr2').create('pwr1', 'PlaneWaveRadiation', 1);
model.physics('acpr2').feature('pwr1').selection.set([14 15]);
model.physics('acpr2').feature('pwr1').create('ipf1', 'IncidentPressureField', 1);
model.physics('acpr2').feature('pwr1').feature('ipf1').selection.set([14 15]);

model.mesh('mesh3').autoMeshSize(2);
model.mesh('mesh4').autoMeshSize(2);

model.variable('var2').label('With array');
model.variable('var3').label('Without array');

model.view('view1').axis.set('abstractviewxscale', '0.003661445574834943');
model.view('view1').axis.set('ymin', '-0.16573965549468994');
model.view('view1').axis.set('xmax', '1.263198733329773');
model.view('view1').axis.set('abstractviewyscale', '0.003661445342004299');
model.view('view1').axis.set('abstractviewbratio', '-0.08181582391262054');
model.view('view1').axis.set('abstractviewtratio', '0.08181582391262054');
model.view('view1').axis.set('abstractviewrratio', '0.04999999329447746');
model.view('view1').axis.set('xmin', '-1.263198733329773');
model.view('view1').axis.set('abstractviewlratio', '-0.04999999329447746');
model.view('view1').axis.set('ymax', '1.2805312871932983');
model.view('view3').label('View 3');
model.view('view3').axis.set('abstractviewxscale', '0.003661445574834943');
model.view('view3').axis.set('ymin', '-0.20757079124450684');
model.view('view3').axis.set('xmax', '1.336270809173584');
model.view('view3').axis.set('abstractviewyscale', '0.003661445342004299');
model.view('view3').axis.set('abstractviewbratio', '-0.08181582391262054');
model.view('view3').axis.set('abstractviewtratio', '0.08181582391262054');
model.view('view3').axis.set('abstractviewrratio', '0.04999999329447746');
model.view('view3').axis.set('xmin', '-1.336270809173584');
model.view('view3').axis.set('abstractviewlratio', '-0.04999999329447746');
model.view('view3').axis.set('ymax', '1.3223624229431152');

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
model.physics('acpr').feature('pwr1').feature('ipf1').set('dir', {'sin(theta_i)' '-cos(theta_i)' '0'});
model.physics('acpr').feature('pwr1').feature('ipf1').set('p_i', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(sigma^2))*exp(-1i*acpr.k*(sin(theta_i)*x-cos(theta_i)*y))');
model.physics('acpr').feature('pwr1').feature('ipf1').set('pamp', 'exp(-((y-0.4+D/2-(25*0.025685-0.4*tan(theta_i))/tan(theta_i))/0.5)^2)');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('IncidentPressureFieldType', 'UserDefined');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('dir', {'sin(theta_i)' '-cos(theta_i)' '0'});
model.physics('acpr2').feature('pwr1').feature('ipf1').set('p_i', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(sigma^2))*exp(-1i*acpr2.k*(sin(theta_i)*x-cos(theta_i)*y))');
model.physics('acpr2').feature('pwr1').feature('ipf1').set('pamp', 'exp(-((x+R*sin(theta_i))^2+(y-R*cos(theta_i))^2)/(0.5^2))*exp(-1i*acpr.k*(sin(theta_i)*x-cos(theta_i)*y))');

model.mesh('mesh3').run;
model.mesh('mesh4').run;

model.comments(['Untitled\n\nOptimization\n\nMy normal absorption\n\n']);
model.comments(['Untitled\n\nOptimization\n\nMy normal absorption\n\n']);
model.comments(['Untitled\n\nOptimization\n\nMy normal absorption\n\n']);

model.variable.create('var4');

model.comments(['Untitled\n\nOptimization\n\nMy normal absorption\n\n']);

model.variable.remove('var4');

model.comments(['Untitled\n\nOptimization\n\nMy normal absorption\n\n']);

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study('std1').feature('freq').activate('acpr', true);
model.study('std1').feature('freq').activate('acpr2', true);
model.study('std1').feature('freq').set('showdistribute', false);

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('freq').set('notlistsolnum', 1);
model.study('std1').feature('freq').set('notsolnum', '1');
model.study('std1').feature('freq').set('listsolnum', 1);
model.study('std1').feature('freq').set('solnum', '1');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').set('stol', 0.001);
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {''});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('aDef').set('matherr', true);
model.sol('sol1').feature('s1').feature('aDef').set('blocksize', 1000);
model.sol('sol1').feature('s1').feature('aDef').set('blocksizeactive', false);
model.sol('sol1').feature('s1').create('seDef', 'Segregated');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature('s1').feature.remove('seDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 2);
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg1').label('Acoustic Pressure (acpr)');
model.result.create('pg2', 2);
model.result('pg2').set('data', 'dset1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'acpr.Lp'});
model.result('pg2').label('Sound Pressure Level (acpr)');
model.result.create('pg3', 2);
model.result('pg3').set('data', 'dset2');
model.result('pg3').create('surf1', 'Surface');
model.result('pg3').feature('surf1').set('expr', {'acpr2.p_t'});
model.result('pg3').label('Acoustic Pressure (acpr2)');
model.result.create('pg4', 2);
model.result('pg4').set('data', 'dset2');
model.result('pg4').create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('expr', {'acpr2.Lp'});
model.result('pg4').label('Sound Pressure Level (acpr2)');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.remove('pg4');
model.result.remove('pg3');

model.study('std1').feature('freq').set('showdistribute', false);
model.study('std1').feature('freq').set('plist', 'range(600,200,3000)');

model.sol('sol1').study('std1');

model.study('std1').feature('freq').set('notlistsolnum', 1);
model.study('std1').feature('freq').set('notsolnum', '1');
model.study('std1').feature('freq').set('listsolnum', 1);
model.study('std1').feature('freq').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').set('stol', 0.001);
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'range(600,200,3000)'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('aDef').set('matherr', true);
model.sol('sol1').feature('s1').feature('aDef').set('blocksize', 1000);
model.sol('sol1').feature('s1').feature('aDef').set('blocksizeactive', false);
model.sol('sol1').feature('s1').create('seDef', 'Segregated');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature('s1').feature.remove('seDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 2);
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg1').label('Acoustic Pressure (acpr)');
model.result.create('pg2', 2);
model.result('pg2').set('data', 'dset1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'acpr.Lp'});
model.result('pg2').label('Sound Pressure Level (acpr)');
model.result.create('pg3', 2);
model.result('pg3').set('data', 'dset2');
model.result('pg3').create('surf1', 'Surface');
model.result('pg3').feature('surf1').set('expr', {'acpr2.p_t'});
model.result('pg3').label('Acoustic Pressure (acpr2)');
model.result.create('pg4', 2);
model.result('pg4').set('data', 'dset2');
model.result('pg4').create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('expr', {'acpr2.Lp'});
model.result('pg4').label('Sound Pressure Level (acpr2)');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg1').setIndex('looplevel', '5', 0);
model.result('pg1').run;
model.result('pg1').setIndex('looplevel', '10', 0);
model.result('pg1').run;

model.func('an2').set('expr', '1+d_nr_max/2+d_nr(floor(x/d)*d)');
model.func('wv1').set('smoothactive', 'off');
model.func('an2').set('expr', '1+d_nr_max/2+d_nr(floor(x/d)*d+period/2)');

model.study('std1').feature('freq').set('showdistribute', false);

model.sol('sol1').study('std1');

model.study('std1').feature('freq').set('notlistsolnum', 1);
model.study('std1').feature('freq').set('notsolnum', '1');
model.study('std1').feature('freq').set('listsolnum', 1);
model.study('std1').feature('freq').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').set('stol', 0.001);
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'range(600,200,3000)'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('aDef').set('matherr', true);
model.sol('sol1').feature('s1').feature('aDef').set('blocksize', 1000);
model.sol('sol1').feature('s1').feature('aDef').set('blocksizeactive', false);
model.sol('sol1').feature('s1').create('seDef', 'Segregated');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature('s1').feature.remove('seDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result.create('pg5', 'PlotGroup2D');
model.result('pg5').run;
model.result('pg5').create('surf1', 'Surface');
model.result.dataset.create('join1', 'Join');
model.result.dataset('join1').set('data', 'dset1');
model.result.dataset('join1').set('data2', 'dset2');
model.result.dataset('join1').set('method', 'explicit');
model.result('pg3').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('expr', 'data1(acpr.p_t)-data2(acpr2.p_t)');
model.result('pg5').run;
model.result('pg5').set('data', 'join1');
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecoloractive', 'on');
model.result('pg5').feature('surf1').set('rangecolormin', '-1');
model.result('pg5').feature('surf1').set('rangecolormax', '1');
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', '5', 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', '9', 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', '11', 0);
model.result('pg5').run;

out = model;
