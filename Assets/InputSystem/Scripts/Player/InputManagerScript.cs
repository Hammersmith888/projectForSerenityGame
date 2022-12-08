using UnityEngine;

public class InputManagerScript : MonoBehaviour
{

    private static InputManagerScript _instance;

    public static InputManagerScript Instance
    {
        get
        {
            return _instance;
        }
        
    }
   
    private InputManager inputManager;

    private void Awake()
    {
        if(_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
        inputManager = new InputManager();
        Cursor.visible = false;
    }

    private void OnEnable() // Запуск действия 
    {
        inputManager.Enable();
    }

    private void OnDisable() // Отключение действия
    {
        inputManager.Disable();
    }

    public Vector2 GetPlayerMovement()
    {
        return inputManager.Player.Movement.ReadValue<Vector2>();
    }

    public Vector2 GetMouseDelta()
    {
        return inputManager.Player.Look.ReadValue<Vector2>();
    }

    public bool PlayerRun()
    {
        return inputManager.Player.Run.triggered;
    }
}
