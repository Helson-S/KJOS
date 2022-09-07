extern void __attribute__((__cdecl__)) b_func (char *ptr, int num);

void a_func(char *ptr)
{
    int a = 0;
    b_func(ptr, 3);
}
