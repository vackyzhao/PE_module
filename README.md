#1.1   设计目的
在日益便捷的信息获取和传递中，听障人士却因听力损害而面临交流难题。这一设计以普及化先进科技，改善听障人士生活为目标，利用红外摄像技术和嵌入式硬件，将手语拼写高效转换为文本，提供更加便捷的交流方式。
 
#1.2   应用领域
本设计可以应用于听障人士的日常生活，通过提供便捷的手语输入方式改善他们的交流体验。同时，也能用于帮助非听障人士理解和学习手语，促进信息无障碍交流。
 
#1.3   主要技术特点
设计以红外摄像头获取手势图像，它能提供比常规摄像头更清晰的手势细节，并能适应各种环境，保证在任何条件下都能获得高质量图像。同时，本设计的嵌入式硬件具有针对卷积神经网络特别优化后的计算能力，可利用乘加器和脉动阵列的技术快速推理卷积升级网络，较准确地识别出手势图像。
 
#1.4   关键性能指标
设计硬件采用单通道24×32像素的红外摄像头，能精准捕捉并清晰显示手势细节，节省传统算法在数据预处理中耗费的时间和片上资源。并且，本设计使用的乘积器和脉动整列，使得处理图片转化的速度远超传统CPU的ALU运算。
 
#1.5   主要创新点
（1）运用红外摄像头捕捉手势图像，保证图像的高清晰度和强抗干扰能力。
（2）采用脉动阵列进行卷积神经网络推理加速，提升了手势识别的速度。
（3）自主拍摄了适用于这一特殊需求的数据集，包括了标准的ASL手语手势以及非手势的背景图像。
（4）采用了自适应激活函数以提高卷积神经网络的精度。
