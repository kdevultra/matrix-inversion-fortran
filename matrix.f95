module matrix_module

	implicit none
	! new types declarations
	type matrix_type
		integer :: m, n
		real, dimension(:,:), allocatable :: data2D
	end type matrix_type
	
contains

	! subroutines and functions
	
	! create the matrix object from the 2D array
	subroutine create_matrix(m, n, array2D, matrix_obj)
		
		implicit none
		
		integer :: m, n, as
		type(matrix_type), intent(out) :: matrix_obj
		real, dimension(m,n), intent(in) :: array2D
		integer :: i=1, j=1
		
		matrix_obj%m = m
		matrix_obj%n = n
		
		allocate(matrix_obj%data2D(m,n), stat=as)
		
		! copy the array into the matrix object
		do i = 1, m
			do j = 1, n
				matrix_obj%data2D(i,j) = array2D(i,j)
			end do
		end do
		
		! normally at the creation, basics information should be calculated : rank, determinant, etc.
		
		return
		
	end subroutine create_matrix
	
	! display the matrix
	subroutine display_matrix(matrix)
	
		type(matrix_type) :: matrix
		integer :: m,n, i,j
		
		m = matrix%m
		n = matrix%n
		
		do j = 1, m
			do i = 1, n
				write(*, "(f6.3)", advance="no") matrix%data2D(j, i)  
			end do
			write(*,*) " "
		end do
		
		return
		
	end subroutine display_matrix
	
	! inverse the matrix
    	subroutine invert_matrix(matrix_A, matrix_A_inv, invertible)
        
        		implicit none
        
	        ! type declarations
        		type(matrix_type), intent(in) :: matrix_A
	        type(matrix_type), intent(out) :: matrix_A_inv
        		logical, intent(out) :: invertible
        
        		! matrix_U, matrix_P, matrix_I removed as they belong to LU decomposition, 
        		! not the augmented Gauss-Jordan method.
        		type(matrix_type) :: matrix_M 
        
        		integer :: i, j, k, p, n, alloc_state
        		real(8) :: max_val, temp_val, pivot, factor
        
        		! operations
        		write(*,*) "Inverting the matrix..."
        
        		! 1. check the invertibility of the matrix 
	        call is_invertible(matrix_A, invertible)
        
	        if (invertible .eqv. .false.) then
        		    write(*,*) "Matrix is not invertible."
        		    stop
	        end if

	        ! Get matrix dimension (Assumes matrix_type has a %data array or similar structure. 
	        n = matrix_A%n

        		! Gauss-Jordan inversion algo
        		! 1. Initialize the augmented matrix (constructing an n x 2n matrix)
	        call generate_augmented_matrix(matrix_A, matrix_M)
        
        		! 2. Column elimination
	        do k = 1, n
            
            		! 2a. Partial Pivoting: prevent division by 0 and minimize rounding errors
            		p = k
            		max_val = abs(matrix_M%data2D(k, k))
            
            		! Find the row with the largest absolute value in the current column k
            		do i = k + 1, n
                			if (abs(matrix_M%data2D(i, k)) > max_val) then
                    			max_val = abs(matrix_M%data2D(i, k))
                    			p = i
                			end if
            		end do
            
            		! Safety check for numerical singularity during elimination
            		if (max_val < 1.0d-12) then
                			write(*,*) "Matrix is numerically singular. Cannot invert."
                			invertible = .false.
                			return
            		end if
            
            		! Swap row k and row p if the maximum value is not already in row k
            		if (p /= k) then
                			do j = k, 2 * n
                    			temp_val = matrix_M%data2D(k, j)
                    			matrix_M%data2D(k, j) = matrix_M%data2D(p, j)
                    			matrix_M%data2D(p, j) = temp_val
                			end do
            		end if
            
            		! 2b. Normalize the Pivot Row (force the diagonal pivot element to 1)
            		pivot = matrix_M%data2D(k, k)
            		! Iteration starts at k because columns to the left are already 0
            		do j = k, 2 * n
                			matrix_M%data2D(k, j) = matrix_M%data2D(k, j) / pivot
            		end do
            
            		! 2c. Eliminate All Other Rows (zero out the rest of column k)
            		do i = 1, n
                			if (i /= k) then
                    			factor = matrix_M%data2D(i, k)
                    			do j = k, 2 * n
                        				matrix_M%data2D(i, j) = matrix_M%data2D(i, j) - (factor * matrix_M%data2D(k, j))
                    			end do
                			end if
            		end do
            
        		end do
        
        		! 3. Extract the n x n result
        		! The right half of the augmented matrix M now contains the inverse.
        		! Copies columns n+1 to 2n from M into columns 1 to n of matrix_A_inv.
        		
		matrix_A_inv%m = matrix_A%m
		matrix_A_inv%n = matrix_A%n
		
		! allocate the size for matrix's data
		allocate(matrix_A_inv%data2D(matrix_A%m, matrix_A%n), stat=alloc_state)
		if (alloc_state .ne. 0) stop "Matrix allocation failed. Stopping program."
        		
        		do i = 1, n
            		do j = 1, n
                			matrix_A_inv%data2D(i, j) = matrix_M%data2D(i, j + n)
            		end do
        		end do
        
        		return
        
    	end subroutine invert_matrix
	
	subroutine generate_augmented_matrix(matrix, matrix_augmented)
	
		implicit none
		
		type(matrix_type), intent(in) :: matrix
		type(matrix_type), intent(out) :: matrix_augmented
		integer :: i,j, alloc_state
		
		! size of augmented is n x 2n
		matrix_augmented%m = matrix%m
		matrix_augmented%n = 2 * matrix%n
		
		! allocate the size for matrix's data
		allocate(matrix_augmented%data2D(matrix%m, 2 * matrix%n), stat=alloc_state)
		if (alloc_state .ne. 0) stop "Matrix allocation failed. Stopping program."
		
		! 1. copy the original matrix to the left half
		do i = 1, matrix%m
			do j = 1, matrix%n
				matrix_augmented%data2D(i,j) = matrix%data2D(i,j) 
			end do
		end do
		
		! 2. build the identity matrix in the right half
		do i = 1, matrix%m
			do j = 1, matrix%n
				if (i==j) then
					matrix_augmented%data2D(i, j + matrix%n) = real(1)
				else
					matrix_augmented%data2D(i, j + matrix%n) = real(0)
				end if
			end do
		end do
	
		return
		
	end subroutine generate_augmented_matrix
	
	subroutine generate_identity_matrix(m,n,matrix_identity)
		
		implicit none
		
		integer :: m,n, i,j
		type(matrix_type), intent(out) :: matrix_identity
		
		matrix_identity%m = m
		matrix_identity%n = n
		
		do i = 1, m
			do j = 1, n
				if (i == j) then
					matrix_identity%data2d(i,j) = 1
				else 
					matrix_identity%data2d(i,j) = 0
				end if
			end do
		end do
		
		return
		
	end subroutine generate_identity_matrix
	
	subroutine copy_matrix(matrix_origin, matrix_destination)
		
		implicit none
		
		type(matrix_type), intent(in) :: matrix_origin
		type(matrix_type), intent(out) :: matrix_destination
		integer :: i,j
		
		matrix_destination%m = matrix_origin%m
		matrix_destination%n = matrix_origin%n
		
		do i = 1, matrix_origin%m
			do j = 1, matrix_origin%n
				matrix_destination%data2D(i,j) = matrix_origin%data2D(i,j) 
			end do
		end do
		
		return
		
	end subroutine copy_matrix
	
	! invertible state of the matrix
	! the only condition that is checked here is if the matrix is squared or not
	subroutine is_invertible(matrix, invertible)
	
		implicit none
		
		type(matrix_type), intent(in) :: matrix
		logical, intent(out) :: invertible

		if(matrix%m == matrix%n) then
			invertible = .true.	
		else 
			invertible = .false.
			write(*,*) "Dimensions don't match."
		end if
	
	end subroutine is_invertible 

end module matrix_module
