function goal = absSum(c1,c2,c3,c4)
model = mphload('optimization.mph');
list = [];
model.param.set('c1', num2str(c1));
model.param.set('c2', num2str(c2));
model.param.set('c3', num2str(c3));
model.param.set('c4', num2str(c4));
for i=[200,260,320,380,440,600,900,1200,1500,1800,2100,2400,2700,3000];
    model.study('std1').feature('param').set('plistarr', num2str(i));
    model.study('std1').run;
    temp = mphglobal(model,{'comp1.p_with/comp2.p_without'});
    %display(model.mphglobal('R'))
    list = [list, temp];
end
%display(num2str(c1)+' '+num2str(c2)+' '+num2str(c3)+' '+num2str(c4))
display(list)
goal = -sum(list);