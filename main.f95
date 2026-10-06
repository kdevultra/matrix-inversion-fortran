program main
	use matrix_module
	implicit none
	
	! type declarations
	integer :: m, n
	type(matrix_type) :: matrix, matrix_M
	type(matrix_type) :: matrix_inv
	logical :: invertible
	real :: x
	character(20) :: filename="matrix_data.csv"
	
	! reading the size of the matrix
	write(*,*) "Enter the dimensions of the matrix in the data file :"
	read(*,*) m, n
	
	! reading the matrix from the filename
	write(*,*) "Now reading the matrix data from ´matrix_data.csv´..."
	call read_matrix(filename, matrix, m, n)
	write(*,*) "Data read successfully."
	
	! display the matrix
	write(*,*) "Displaying the matrix A:"
	call display_matrix(matrix)
	
	! Test on the augmented matrix
	! write(*,*) "Displaying the inverse computed matrix..."
	!call generate_augmented_matrix(matrix, matrix_M)
	!write(*,*) "Displaying augmented matrix."
	!call display_matrix(matrix_M)
	
	write(*,*) "Now inverting the matrix..."
	call invert_matrix(matrix, matrix_inv, invertible)
	
	if (invertible .eqv. .false.) then
		write(*,*) "The matrix is not invertible."
		return
	else
		write(*,*) "Displaying the inverted matrix :"
		call display_matrix(matrix_inv)
	end if
	
contains
	! subroutines and functions
	
	subroutine read_matrix(filename, matrix, m, n)
        
    		implicit none
    
    		character(20), intent(in) :: filename
    		integer, intent(in) :: m, n
    		type(matrix_type), intent(out) :: matrix
    
    		integer :: openstatus, read_status, i, j, alloc_state
    		real :: k
    
    		! setting the dimensions of the matrix type
    		matrix%m = m
    		matrix%n = n
    
    		! allocate the size for matrix's data
    		allocate(matrix%data2D(m, n), stat=alloc_state)
    		if (alloc_state .ne. 0) stop "Matrix allocation failed. Stopping program."
    
    		! reading the data
    		open(unit=1, file=filename, action='read', iostat=openstatus)
    
    		if (openstatus .ne. 0) then
        			print*, "File not opened."
		        	stop
    		end if
    
    		! FIX: Read the entire row at once using an implied do-loop
    		do i = 1, m
        			read(unit=1, fmt=*, iostat=read_status) (matrix%data2D(i, j), j = 1, n)
        			if (read_status .ne. 0) then
            			print*, "Error reading data at row ", i
            			stop	
        			end if
    		end do
    
    		close(unit=1)
    
    		print*, "File read correctly."
    
    		return

	end subroutine read_matrix
	
	subroutine generate_matrix(m, n, matrix)
		
		implicit none
		
		integer :: m,n, i,j
		type(matrix_type), intent(out) :: matrix
		real, dimension(m,n) :: array2D
		real :: x
		
		call random_seed()
		
		do i = 1, m
			do j = 1, n
				call random_number(x)
				array2D(i,j) = (real(i) / real(j)) * x
			end do 
		end do 
		
		! now generating the matrix object
		call create_matrix(m, n, array2D, matrix)
		
		return
		
	end subroutine generate_matrix

end program main
