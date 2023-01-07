## 如何使用

- 在**没有**MATLAB的电脑上运行，**先执行**for_redistribution内的安装包，**再执行**for_redistribution_files_only内程序即可。
- 在**有**MATLAB的电脑上运行，**直接执行**for_redistribution_files_only内程序即可。打包后的程序文件一般默认保存在.m程序所在的文件夹里，找到for_redistribution_files_only文件夹，里面的exe文件即为打包后的可编辑文件，双击exe文件便可打开MATLAB程序

## 文件说明

- `.prj`:MATLAB编译项目文件
- `for_redistribution`：依赖环境安装包
- `for_redistribution_files_only`：执行文件所在目录
- `for_testing`：测试目录一般不管

## 注意

- 编译前请命令窗口执行`compiler.runtime.download`下载MATLAB的runtime模块。

- 编译生成exe文件过程中报错`mccs失败/MATLAB_Runtime_R2022a_win64.zip无效`，这表明你使用的MATLAB版本**破解不完全**，请重新破解再进行编译。
## 编译参考
- https://blog.csdn.net/weixin_36159518/article/details/126042709?spm=1001.2014.3001.5501
- https://blog.csdn.net/weixin_45496759/article/details/120320858

  

