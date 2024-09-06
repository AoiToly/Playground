Eigon库

using语法

```c++
template<typename T> using Mat2 = Matrix<T, 2, 2>;
int main()
{
	Mat2<int> mat1;
	mat1 << 1, 1, 
			1, 1;
	couat << mat1 <<endl;
	return 0;
}
```

常用矩阵

```c++
MatrixXd mat1 = MatrixXd::Zero(2, 2);		// 全0矩阵
MatrixXd mat2 = MatrixXd::Ones(2, 2);		// 全1矩阵
MatrixXd mat3 = MatrixXd::Identity(2, 2);	// 单位矩阵
MatrixXd mat4 = MatrixXd::Random(2, 2);		// 随机矩阵
```

特殊矩阵

```c++
MatrixXd mat = MatrixXd::Random(3, 3);
cout << mat.transpose() <<end;	// 转置矩阵
cout << mat.conjugate() <<end;	// 共轭矩阵
cout << mat.inverse() <<end;	// 逆矩阵
cout << mat.adjoint() <<end;	// 伴随矩阵
```

向量块操作

```c++
 ArrayXd vec(9);
 vec << 1, 2, 3, 4, 5, 6, 7, 8, 9;
 cout << vec << endl;
 cout << vec.head(3) << endl;		// 抽取前3个元素
 cout << vec.tail(3) << endl;		// 抽取后3个元素
 cout << vec.segment(3, 4) <<endl;	// 从下标为3的元素开始，抽取4个元素
```

矩阵块操作

```c++
MatrixXd mat(4, 4);
mat << 1, 2, 3, 4,
	5, 6, 7, 8, 
	9, 10, 11, 12,
	13, 14, 15, 16;
cout << mat.col(3) << endl;		// 打印第4列
cout << mat.row(3) << endl;		// 打印第4行
cout << mat.block(1, 1, 2, 2) << endl;	// 从点(1, 1)开始打印一个2 * 2的矩阵
cout << mat.block<2, 2>(1, 1) << endl;	// 从点(1, 1)开始打印一个2 * 2的矩阵
```

