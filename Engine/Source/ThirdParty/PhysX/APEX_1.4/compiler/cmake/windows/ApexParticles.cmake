#
# Build APEX_Particles
#

SET(GW_DEPS_ROOT $ENV{GW_DEPS_ROOT})
FIND_PACKAGE(PxShared REQUIRED)

SET(APEX_MODULE_DIR ${PROJECT_SOURCE_DIR}/../../../module)

SET(AM_SOURCE_DIR ${APEX_MODULE_DIR}/particles)

FIND_PACKAGE(nvToolsExt REQUIRED)

# Set the CUDA includes, etc.
INCLUDE(../common/SetupCUDA.cmake)

SET(APEX_PARTICLES_PLATFORM_INCLUDES
	${NVTOOLSEXT_INCLUDE_DIRS}
	${Boost_INCLUDE_DIRS}
	${CUDA_INCLUDE_DIRS}

	${PXSHARED_ROOT_DIR}/include/cudamanager
	${PROJECT_SOURCE_DIR}/../../../common/include/windows

	${PHYSX_ROOT_DIR}/Source/PhysXGpu/include
	${PHYSX_ROOT_DIR}/Include/gpu

	${APEX_MODULE_DIR}/particles/include/windows
)

SET(APEX_PARTICLES_COMPILE_DEFS


	# Common to all configurations
	${APEX_WINDOWS_COMPILE_DEFS};ENABLE_TEST=0;EXCLUDE_CUDA=1;EXCLUDE_PARTICLES=1;_USRDLL;

	$<$<CONFIG:debug>:${APEX_WINDOWS_DEBUG_COMPILE_DEFS};>
	$<$<CONFIG:checked>:${APEX_WINDOWS_CHECKED_COMPILE_DEFS};>
	$<$<CONFIG:profile>:${APEX_WINDOWS_PROFILE_COMPILE_DEFS};>
	$<$<CONFIG:release>:${APEX_WINDOWS_RELEASE_COMPILE_DEFS};>
)

# include common ApexParticles.cmake
INCLUDE(../common/ApexParticles.cmake)

# Do final direct sets after the target has been defined
TARGET_LINK_LIBRARIES(APEX_Particles ${NVTOOLSEXT_LIBRARIES} ${CUDA_CUDA_LIBRARY} DelayImp.lib 
	PhysXCommon PhysX PhysXExtensions PhysXVehicle 
	APEX_BasicFS APEX_BasicIOS APEX_Emitter APEX_FieldSampler APEX_ForceField APEX_IOFX APEX_ParticleIOS
	ApexCommon ApexFramework ApexShared
	NvParameterized PsFastXml PxCudaContextManager PxFoundation PxPvdSDK
)

IF(CMAKE_CL_64)
	SET(LIBPATH_SUFFIX "x64")
ELSE(CMAKE_CL_64)
	SET(LIBPATH_SUFFIX "Win32")
ENDIF(CMAKE_CL_64)				

SET_TARGET_PROPERTIES(APEX_Particles PROPERTIES 
	LINK_FLAGS_DEBUG "/DELAYLOAD:nvcuda.dll"
	LINK_FLAGS_CHECKED "/DELAYLOAD:nvcuda.dll"
	LINK_FLAGS_PROFILE "/DELAYLOAD:nvcuda.dll"
	LINK_FLAGS_RELEASE "/DELAYLOAD:nvcuda.dll"
)
