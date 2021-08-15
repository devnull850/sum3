	.global start
	.global main

	.text
main:
	push	%rbp
	movq	%rsp,%rbp
	add	$0xffffffffffffffd0,%rsp
	movl	%edi,0xfffffffffffffffc(%rbp)	# argc
	movq	%rsi,0xffffffffffffffe8(%rbp)	# argv
	xor	%eax,%eax
	xor	%edi,%edi
	lea	0xffffffffffffffd0(%rbp),%rsi
	movl	$0x20,%edx
	syscall					# read(stdin, buf, 32)
	movl	%eax,%edx
	lea	0xffffffffffffffd0(%rbp),%rax
	add	%rax,%rdx
	dec	%rdx
	movb	$0,(%rdx)
	xor	%ecx,%ecx
	xor	%edx,%edx
.sum1:
	movb	(%rax),%dl
	test	%dl,%dl
	je	.num2
	imul	$0xa,%ecx,%ecx
	add	$0xffffffd0,%edx
	add	%edx,%ecx
	inc	%rax
	jmp	.sum1
.num2:
	movl	%ecx,0xfffffffffffffff8(%rbp)	# n1
	xor	%eax,%eax
	xor	%edi,%edi
	lea	0xffffffffffffffd0(%rbp),%rsi
	movl	$0x20,%edx
	syscall					# read(stdin, buf, 32)
	movl	%eax,%edx
	lea	0xffffffffffffffd0(%rbp),%rax
	add	%rax,%rdx
	dec	%rdx
	movb	$0,(%rdx)
	xor	%ecx,%ecx
	xor	%edx,%edx
.sum2:
	movb	(%rax),%dl
	test	%dl,%dl
	je	.sum0
	imul	$0xa,%ecx,%ecx
	add	$0xffffffd0,%edx
	add	%edx,%ecx
	inc	%rax
	jmp	.sum2
.sum0:
	movl	0xfffffffffffffff8(%rbp),%eax
	add	%ecx,%eax
	movl	%eax,%edx
	lea	0xffffffffffffffd0(%rbp),%rax
	add	$0x20,%rax
	xor	%ecx,%ecx
	movb	$0,(%rax)
	dec	%rax
	inc	%ecx
	movb	$0xa,(%rax)
	dec	%rax
	inc	%ecx
	push	%rbx
	xor	%ebx,%ebx
.str:
	test	%edx,%edx
	je	.out
	movl	%edx,%ebx
	shr	$4,%edx
	and	$0xf,%ebx
	cmp	$0xa,%ebx
	jl	.dig
	add	$0x57,%ebx
	jmp	.cpy
.dig:
	add	$0x30,%ebx
.cpy:
	movb	%bl,(%rax)
	dec	%rax
	inc	%ecx
	jmp	.str
.out:
	pop	%rbx
	movb	$0x78,(%rax)
	dec	%rax
	inc	%ecx
	movb	$0x30,(%rax)
	inc	%ecx
	movq	%rax,%rsi
	movl	$1,%eax
	movl	$1,%edi
	movl	%ecx,%edx
	syscall
	xor	%eax,%eax
	add	$0x30,%rsp
	leave
	ret
start:
	pop	%rdi
	movq	%rsp,%rsi
	call	main
	movl	%eax,%edi
	movl	$0x3c,%eax
	syscall
