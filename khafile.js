var project = new Project('spriter_test');

project.addSources('Sources');
project.addShaders('Sources/Shaders/**');
project.addLibrary('spriter');
project.addLibrary('spriterkha');
project.addLibrary('imagesheet');

project.addAssets('Assets/**');

return project;
