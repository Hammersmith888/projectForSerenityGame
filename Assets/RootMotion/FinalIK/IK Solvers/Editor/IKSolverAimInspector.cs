using UnityEngine;
using UnityEditor;
using System.Collections;
using System;

	namespace RootMotion.FinalIK {

	/*
	 * Custom inspector and scene view tools for IKSolverAim
	 * */
	public class IKSolverAimInspector: IKSolverInspector {

		#region Public methods
		
		/// <summary>
		/// Draws the custom inspector for IKSolverAim
		/// </summary>
		public static void AddInspector(SerializedProperty prop, bool editHierarchy) {
			IKSolverHeuristicInspector.AddTarget(prop);
			EditorGUILayout.PropertyField(prop.FindPropertyRelative("poleTarget"), new GUIContent("Pole Target", "If assigned, will automatically set polePosition to the position of this Transform."));

			EditorGUILayout.PropertyField(prop.FindPropertyRelative("transform"), new GUIContent("Aim Transform", "The transform that's you want to be aimed at IKPosition. Needs to be a lineal descendant of the bone hierarchy."));
			EditorGUILayout.PropertyField(prop.FindPropertyRelative("axis"), new GUIContent("Axis", "The local axis of the Transform that you want to be aimed at IKPosition."));
			EditorGUILayout.PropertyField(prop.FindPropertyRelative("poleAxis"), new GUIContent("Pole Axis", "Keeps that axis of the Aim Transform directed at the polePosition."));

			EditorGUILayout.Space();
			IKSolverHeuristicInspector.AddIKPositionWeight(prop);

			EditorGUILayout.PropertyField(prop.FindPropertyRelative("poleWeight"), new GUIContent("Pole Weight", "The weight of the Pole."));

			IKSolverHeuristicInspector.AddProps(prop);

			EditorGUILayout.PropertyField(prop.FindPropertyRelative("clampWeight"), new GUIContent("Clamp Weight", "Clamping rotation of the solver. 0 is free rotation, 1 is completely clamped to transform axis."));
			EditorGUILayout.PropertyField(prop.FindPropertyRelative("clampSmoothing"), new GUIContent("Clamp Smoothing", "Number of sine smoothing iterations applied on clamping to make the clamping point smoother."));

			IKSolverHeuristicInspector.AddBones(prop, editHierarchy, true);
		}
		
		/// <summary>
		/// Draws the scene view helpers for IKSolverAim
		/// </summary>
		public static void AddScene(IKSolverAim solver, Color color, bool modifiable) {
			// Protect from null reference errors
			if (!solver.IsValid(false)) return;
			if (solver.transform == null) return;
			if (Application.isPlaying && !solver.initiated) return;
			
			Handles.color = color;
			GUI.color = color;
			
			// Display the bones
			for (int i = 0; i < solver.bones.Length; i++) {
				IKSolver.Bone bone = solver.bones[i];

				if (i < solver.bones.Length - 1) Handles.DrawLine(bone.transform.position, solver.bones[i + 1].transform.position);
				Handles.SphereHandleCap(0, solver.bones[i].transform.position, Quaternion.identity, GetHandleSize(solver.bones[i].transform.position), EventType.MouseDown);
			}
			
			if (solver.axis != Vector3.zero) Handles.ConeHandleCap(0, solver.transform.position, Quaternion.LookRotation(solver.transform.rotation * solver.axis), GetHandleSize(solver.transform.position) * 2f, EventType.MouseDown);
			
			// Selecting joint and manipulating IKPosition
			if (Application.isPlaying && solver.IKPositionWeight > 0) {
				if (modifiable) {
					Handles.SphereHandleCap(0, solver.IKPosition, Quaternion.identity, GetHandleSize(solver.IKPosition), EventType.MouseDown);
						
					// Manipulating position
					solver.IKPosition = Handles.PositionHandle(solver.IKPosition, Quaternion.identity);
				}
				
				// Draw a transparent line from transform to IKPosition
				Handles.color = new Color(color.r, color.g, color.b, color.a * solver.IKPositionWeight);
				Handles.DrawLine(solver.bones[solver.bones.Length - 1].transform.position, solver.transform.position);
				Handles.DrawLine(solver.transform.position, solver.IKPosition);
			}

			Handles.color = color;

			// Pole
			if (Application.isPlaying && solver.poleWeight > 0f) {
				if (modifiable) {
					Handles.SphereHandleCap(0, solver.polePosition, Quaternion.identity, GetHandleSize(solver.IKPosition) * 0.5f, EventType.MouseDown);
					
					// Manipulating position
					solver.polePosition = Handles.PositionHandle(solver.polePosition, Quaternion.identity);
				}

				// Draw a transparent line from transform to polePosition
				Handles.color = new Color(color.r, color.g, color.b, color.a * solver.poleWeight);
				Handles.DrawLine(solver.transform.position, solver.polePosition);
			}
			
			Handles.color = Color.white;
			GUI.color = Color.white;
		}
		
		#endregion Public methods

	}
}
