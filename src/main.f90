PROGRAM Projet
        USE lecture
        USE structure
        USE ArrayManip
        USE ecriture
        USE math
        USE energie

        INTEGER                                       :: nAtom,i,n,ncycle,csize,nelec,narom,uff,outfile
        INTEGER, DIMENSION(:,:), ALLOCATABLE          :: D
        CHARACTER(len=32)                             :: fName,outname
        REAL, DIMENSION(:,:), ALLOCATABLE             :: positions,B
        CHARACTER(len=5), DIMENSION(:), ALLOCATABLE   :: names,types
        REAL, DIMENSION(:,:), ALLOCATABLE             :: prop
        CHARACTER(len=2), DIMENSION(10)               :: atomList
        REAL, DIMENSION(10,2)                         :: minMax
        REAL                                          :: benergy,aenergy,vdwenergy,tenergy,ienergy
        INTEGER, DIMENSION(:), ALLOCATABLE            :: discovered


        CALL getarg(1,fName)
        uff=12
        OPEN(UNIT=uff,FILE="data/UFF.dat")
        outfile=15
        outname="OUTPUT"
        OPEN(UNIT=outfile,FILE=outname)
        CALL write_header(outfile)
        CALL read_xyz(fName,positions,names,nAtom)
        CALL connectivity(D,positions,names,nAtom)
        CALL bond_order(D,names,B)
        CALL atom_type_assign(D,B,names,nAtom)
        CALL bond_order_arom(names,B)
        CALL add_element(types,names(1))
        CALL write_positions(outfile,positions,names)
        CALL write_connectivity(outfile,B)
        DO i=2,nAtom
                IF(.NOT. ANY(names(i) == types)) THEN
                        CALL add_element(types,names(i))
                END IF                
        END DO
        ALLOCATE(prop(SIZE(types),11))
        CALL get_uff_properties(types,prop,uff)
        CALL write_uff_properties(outfile,types,prop)
        CALL compute_energy(positions,B,names,types,prop,D,outfile)
        DEALLOCATE(positions)
        DEALLOCATE(names)
        CLOSE(uff)
        CLOSE(outfile)
END PROGRAM

